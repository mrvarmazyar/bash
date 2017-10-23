Interface=eth0
LOG=/var/log/connections/Bandwidth.log
getdata() {
    DATA=`ifconfig $Interface|sed -n 's/\( *RX bytes:\)\([0-9]*\)\([^:]*\):\([0-9]*\)\(.*)\)/\2 \4/p'`
    RX=`echo $DATA|sed -n 's/\([0-9]*\) \(.*\)/\1/p'`
    TX=`echo $DATA|sed -n 's/\([^ ]*\) \(.*\)/\2/p'`
}
getdata
counter=0;      RXT=0;  TXT=0
while true; do
    OLDRX=$RX
    OLDTX=$TX
    getdata
        RXT=$((RXT+RX-OLDRX))
        TXT=$((TXT+TX-OLDTX))
        counter=$((counter+1));
        if [ $counter -eq 60 ]
        then
                counter=0
                echo "------------------------------------" >> $LOG
                date '+%Y-%m-%d %H:%M:00' >> $LOG

                R=`echo "scale=2;$((RXT))/7680000"|bc`
                T=`echo "scale=2;$((TXT))/7680000"|bc`

                echo "RX: $R Mbps" >> $LOG
                echo "TX: $T Mbps" >> $LOG
                RXT=0; TXT=0
        fi
    sleep 1
done


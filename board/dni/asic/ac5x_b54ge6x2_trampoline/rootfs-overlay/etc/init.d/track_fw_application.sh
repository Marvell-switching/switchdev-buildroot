#!/bin/sh


stackbacktrace () {
	rm /tmp/stackbacktrace.txt
	curwd=`pwd`
	cd /proc/$1/task
	for FILE in *; 
		do 
			echo "printing stack backtrace for task $FILE..." >> /tmp/stackbacktrace.txt ;
			cat $FILE/stack >> /tmp/stackbacktrace.txt ; 
		done
	cd $curwd
}

pid=`pidof fw-application`
echo pid of fw app is $pid
ipaddr=`cat /etc/init.d/serverip`
echo ipaddr is $ipaddr
while [ -f /proc/$pid/exe ];
do
	sleep 1;
	if dmesg | grep -q "reply from FW is timed out"; then
		stackbacktrace "$pid"
		kill -11 $pid
		sleep 1;
	fi	
	if dmesg | grep -q "Fw is stuck and became non-operational"; then
		stackbacktrace "$pid"
		kill -11 $pid
		sleep 1;
	fi	
done
if [ -f /core ]
then
	echo core dump exists!!!
	stamp=`date +%s_%N`
	echo stamp is $stamp
	mv /core /core$stamp
	cp /tmp/appDemo_stdout /tmp/appDemo_stdout$stamp
	cp /tmp/stackbacktrace.txt /tmp/stackbacktrace$stamp.txt
	gzip /core$stamp
	gzip /tmp/appDemo_stdout$stamp
	gzip /tmp/stackbacktrace$stamp.txt
	tftp -p -l /core$stamp.gz -r core$stamp.gz $ipaddr
	tftp -p -l /tmp/appDemo_stdout$stamp.gz -r appDemo_stdout$stamp.gz $ipaddr
	tftp -p -l /tmp/stackbacktrace$stamp.txt.gz -r stackbacktrace$stamp.txt.gz $ipaddr
	if [ ! -f /var/log/ri ]
	then
		echo "1" > /var/log/ri
		ridx=1
	else
		idx=$(< /var/log/ri)
		ridx=$(($idx + 1))
		if [ "$ridx" -gt "9" ]; then
			ridx=1
		fi
		echo $ridx > /var/log/ri
	fi
	mkdir -p /var/log/$ridx
	rm -rf /var/log/$ridx/*
	cp /core$stamp.gz /var/log/$ridx/
	cp /tmp/appDemo_stdout$stamp.gz /var/log/$ridx/
	cp /tmp/stackbacktrace$stamp.txt.gz /var/log/$ridx/

	echo core dump upload finished!
fi

#!/bin/bash
PATH=/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/sbin:/usr/local/bin; export PATH
DOMEN="****.ru" # ваш домен делегированный на яндекс
SUB=@ # сабдомен
TOKEN="*********" # токен
RECID="****" # id записи
LOG_FILE=/home/pi/scripts/logs/ya.log
TODAY=$(TZ=":Asia/Tokyo" date)

while true; do
	IP=$(curl -s ifconfig.me)
	YAIP=$(curl -s https://pddimp.yandex.ru/nsapi/get_domain_records.xml?token=$TOKEN | grep -o -P '(?<=id="'$RECID'">).*(?=)' | grep -o '[^:"]\+[^"]\+' | sed -n '1p' | grep -o -P '(?).*(?=</re)')
	echo -n "$TODAY	my IP: $IP	ip in ya_DNS: $YAIP" >> $LOG_FILE
	if [ $IP != $YAIP ]
		then
			RESULT=$(curl -s "https://pddimp.yandex.ru/nsapi/edit_a_record.xml?token=$TOKEN&domain=$DOMEN&subdomain=$SUB&record_id=$RECID&content=$IP&ttl=1800")
			if [[ $RESULT =~ "<error>ok</error>" ]]
				then
  					echo -n "	IP Changed successful" >> $LOG_FILE
  			  	else 
	  		  		echo -n "	Something went wrong" >> $LOG_FILE
			fi
	fi
	echo "" >> $LOG_FILE
sleep 1m; done;
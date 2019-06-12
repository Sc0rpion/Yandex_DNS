#!/bin/bash
PATH=/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/sbin:/usr/local/bin; export PATH
DOMEN="******" # ваш домен делегированный на яндекс
SUB=@ # сабдомен
TOKEN=****** # токен
RECID=****** # id записи
LOG_FILE=logs/yandex_dns/$(TZ=":Asia/Omsk" date +"%m-%d-%Y").log
LOG_CHANGE_IP=logs/change_ip.log

function valid_ip()				#Фунция теста ip адреса  		original: https://www.linuxjournal.com/content/validating-ip-address-bash-script
{
    local  ip=$1
    local  stat=1

    if [[ $ip =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
        OIFS=$IFS
        IFS='.'
        ip=($ip)
        IFS=$OIFS
        [[ ${ip[0]} -le 255 && ${ip[1]} -le 255 \
            && ${ip[2]} -le 255 && ${ip[3]} -le 255 ]]
        stat=$?
    fi
    return $stat
}

while true; do  										# запускаем цикличный цикл
	TODAY=$(TZ=":Asia/Omsk" date)
	
	nc -z 8.8.8.8 53  >/dev/null 2>&1
	online=$?
	
	if [ $online -eq 0 ]; then							# Проверка на наличие интернета
	   
	    IP=$(curl -s ifconfig.me)
		YAIP=$(curl -s https://pddimp.yandex.ru/nsapi/get_domain_records.xml?token=$TOKEN | grep -o -P '(?<=id="'$RECID'">).*(?=)' | grep -o '[^:"]\+[^"]\+' | sed -n '1p' | grep -o -P '(?).*(?=</re)')
		echo -n "$TODAY	my IP: $IP	ip in ya_DNS: $YAIP" >> $LOG_FILE
					
					if ( valid_ip $IP && valid_ip $YAIP); then 				# Проверяем что мы получили корректные ip, а не мусор
						if [ $IP != $YAIP ]
							then
								echo "$TODAY	$IP" >> $LOG_CHANGE_IP
								RESULT=$(curl -s "https://pddimp.yandex.ru/nsapi/edit_a_record.xml?token=$TOKEN&domain=$DOMEN&subdomain=$SUB&record_id=$RECID&content=$IP&ttl=1800")
								if [[ $RESULT =~ "<error>ok</error>" ]]
									then
  									echo -n "	IP Changed successful" >> $LOG_FILE
  							  		else 
				  			  		echo -n "	Something went wrong" >> $LOG_FILE
								fi
						fi
						echo "" >> $LOG_FILE
					else echo "		ip adress is wrong!" >> $LOG_FILE 
					fi
	else
	    echo "$TODAY" Internet is Down >> $LOG_FILE
	fi
	
sleep 1m; done;									# Засыпаем на минуту и повторяем цикл

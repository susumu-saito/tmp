#!/bin/bash

IP_LIST=(
  dev4-test01.suncomm.net
  dev4-test02.suncomm.net
  dev4-test03.suncomm.net
  dev4-test04.suncomm.net
  dev4-test05.suncomm.net
  dev4-test06.suncomm.net
  dev4-test07.suncomm.net
  dev4-test08.suncomm.net
  dev4-test09.suncomm.net
)
LOG_FILE=./ping.log

for ip in ${IP_LIST[@]}
do
  ping_result=$(ping -w 5 $ip | grep '100% packet loss')
  date_result=$(date)

  if [[ -n $ping_result ]]; then
    echo "[SEVERE] server inactive: $ip $date_result" >> $LOG_FILE
    echo $ip | mail -s "[ALERT] server down!! $date_result" $MAILTO
    echo "inactive"
  else
    echo "[INFO] server active: $ip $date_result" >> $LOG_FILE
    echo "active"
  fi
done
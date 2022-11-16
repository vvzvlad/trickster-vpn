#!/bin/bash
#To crontab (export EDITOR=nano; crontab -e)
#@reboot sleep 30 && bash /root/update_exclude_routes.sh > /root/update_routes_log.txt 2>&1
#0 3 * * mon bash /root/update_exclude_routes.sh > /root/update_routes_log.txt 2>&1

function ProgressBar {
  let _progress=(${1}*100/${2}*100)/100
  let _done=(${_progress}*4)/10
  let _left=40-$_done
  _fill=$(printf "%${_done}s")
  _empty=$(printf "%${_left}s")
  printf "\rAdd routes to route table (${1}/${2}): [${_fill// /#}${_empty// /-}] ${_progress}%%"
}

#Variables
file_raw="russian_subnets_list_raw.txt"
file_user="subnets_user_list.txt"
file_user_hostnames="hosts_user_list.txt"
file_for_calc="russian_subnets_list_raw_for_calc.txt"
file_processed="russian_subnets_list_processed.txt"
gateway_for_internal_ip=`ip route | awk '/default/ {print $3; exit}'`
interface=`ip link show | awk -F ': ' '/state UP/ {print $2}'`

#Get addresses RU segment
echo "Download RU subnets..."
curl --progress-bar "https://stat.ripe.net/data/country-resource-list/data.json?resource=ru" | jq -r ".data.resources.ipv4[]" > $file_raw

echo "Deaggregate subnets..."
cat $file_raw |grep "-" > $file_for_calc
cat $file_raw |grep -v "-" > $file_processed
for line in $(cat $file_for_calc); do ipcalc $line |grep -v "deaggregate" >> $file_processed; done

if [ -e $file_user  ]
then echo "Add user subnets..."
  cat $file_user |grep -v "#" >> $file_processed
fi

if [ -e $file_user_hostnames  ]
then echo "Add user hostnames..."
  for line in $(cat $file_user_hostnames); do nslookup line |grep "Address" |grep -v "#" |awk '{print $2"/32"}' >> $file_processed; done
fi

#Flush route table
echo "Flush route table (down interface $interface)..."
ifdown $interface > /dev/null 2>&1
echo "Up interface $interface..."
ifup $interface > /dev/null 2>&1

#Add route
routes_count_in_file=`wc -l $file_processed`
routes_count_current=0
for line in $(cat $file_processed); do ip route add $line via $gateway_for_internal_ip dev $interface; let "routes_count_current+=1" ; ProgressBar ${routes_count_current} ${routes_count_in_file}; done
echo ""

echo "Remove temp files..."
rm $file_raw $file_processed $file_json $file_for_calc

routes_count=`ip r | wc -l`
echo "Routes in routing table: $routes_count"

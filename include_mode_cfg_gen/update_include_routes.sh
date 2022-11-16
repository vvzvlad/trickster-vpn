#!/bin/bash
#copy this file to your /etc/wireguard

function ProgressBar {
  let _progress=(${1}*100/${2}*100)/100
  let _done=(${_progress}*4)/10
  let _left=40-$_done
  _fill=$(printf "%${_done}s")
  _empty=$(printf "%${_left}s")
  printf "\rAdd routes to route table (${1}/${2}): [${_fill// /#}${_empty// /-}] ${_progress}%%"
}

#Variables
file_user="/etc/wireguard/subnets_user_list.txt"
file_user_hostnames="/etc/wireguard/hosts_user_list.txt"
file_processed="/etc/wireguard/include_subnets_list_processed.txt"
interface_for_external_ip="wg-internal"

if [ -e $file_user  ]
then echo "Add user subnets..."
  cat $file_user |grep -v "#" >> $file_processed
fi

if [ -e $file_user_hostnames  ]
then echo "Add user hostnames..."
  for line in $(cat $file_user_hostnames); do nslookup $line |grep "Address" |grep -v "#"|grep -v ":53" |awk '{print $2"/32"}' >> $file_processed; done
fi

#Flush route table
echo "Flush route table (down interface $interface)..."
ifdown $interface > /dev/null 2>&1
echo "Up interface $interface..."
ifup $interface > /dev/null 2>&1

#Add route
routes_count_in_file=`wc -l $file_processed`
routes_count_current=0
for line in $(cat $file_processed); do ip route add $line dev $interface_for_external_ip; let "routes_count_current+=1" ; ProgressBar ${routes_count_current} ${routes_count_in_file}; done
echo ""

echo "Remove temp files..."
rm $file_processed

routes_count=`ip r | wc -l`
echo "Routes in routing table: $routes_count"

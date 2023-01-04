#! /bin/bash
#UC需安裝sshpass 
#安裝步驟 1. apt update 2. apt install sshpass
#2022_11_27 coding by willis  
#sshpass -p <密碼> ssh -o StrictHostKeyChecking=no <使用者>@<主機> <指令>
#需定義iptable  



# mdtime= echo $(stat ka_diag.log | awk '/Modify/ {print $2}')
mdtime= echo "2022-12-29"
$mdtime

# checkDate= echo $(date -d "yesterday" '+%F')
checkDate= echo "2022-12-29"
$checkDate
# cmd=" echo "moxa" | sshpass -p moxa ssh -o PasswordAuthentication=yes moxa@192.168.13.27 sudo -S fw_printenv 2>&1 | awk -F'=' '/(serialnumber|ethaddr)/ {printf "%s,", $2}'"
sshPass="sshpass -p moxa ssh -o PasswordAuthentication=yes moxa@192.168.13.27 "
echo "moxa" | $sshPass sudo -S fw_printenv 2>&1 | awk -F'=' '/(serialnumber|ethaddr)/ {printf "%s,", $2}'

# if [ $mdtime == $checkDate ];then
#     # echo "相同"
#     echo $( cat /home/moxa/ka_diag.log | grep "$checkDate.*PING"  )
#     sNmac= echo $( fw_printenv | awk -F'=' '/(serialnumber|ethaddr)/ {printf "%s,", $2}' ) #抓取SN/MAC
#     # echo $( $sNmac ",") >> /home/moxa/"$(date +%Y%m).csv"
# else
#     echo "不相同"
# fi
# file="./iptable.csv"  
# #BASEDIR=$(dirname "$0")
# #echo "$BASEDIR"
# for line in $(cat $file)
# do
      
#       #array=(${line//,/ }) 
      		
# 			pwd=$(echo $line | cut -d"," -f 1)
# 			#echo $pwd
# 			ip=$(echo $line | cut -d"," -f 2)
# 			#echo $ip
# 			checkDate=$(echo $(date -d "yesterday" '+%F'))
			
			
			
# 			#echo $checkDate
			
#       cmd="sshpass -p "$pwd" ssh -o stricthostkeychecking=no moxa@"$ip"  cat /var/log/connection_check.log | grep restart | grep "$checkDate" | wc -l"
      
#       #echo $cmd
#       p_checkCount=$($cmd)
#       echo $p_checkCount
#       count=$(ping -c 2 $ip | grep from* | wc -l)
#       if [ $count -gt 0 ]; then
      	
#       	#p_checkCount="$(sshpass -p "$pwd" ssh -o stricthostkeychecking=no $cmd )"
#       	#echo "$(date +%F)"","$ip","$p_checkCount >> ./"$(date +%Y%m).csv"
#       	echo $checkDate","$ip","$p_checkCount >> ./"$(date +%Y%m).csv"
#       else
#       	#echo "$(date +%F)"","$ip",-1" >> ./"$(date +%Y%m).csv"
#       	echo $checkDate","$ip",-1" >> ./"$(date +%Y%m).csv"
#       fi   

# done
# echo "finish"

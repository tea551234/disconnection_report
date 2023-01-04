#! /bin/bash
#2022_11_27 coding by willis  
#2023_01_04 coding by teaya  





#需定義iptable / pwd,ip,id
file="./iptable.csv"  

for line in $(cat $file)
    do
        pwd=$(echo $line | cut -d"," -f 1)
		ip=$(echo $line | cut -d"," -f 2)
		id=$(echo $line | cut -d"," -f 3)
        # checkDate=$(echo $(date -d "yesterday" '+%F'))
        sshPass="sshpass -p "$pwd" ssh -o PasswordAuthentication=yes moxa@"$ip" " #ssh連線 
        mdtime= echo $(stat ka_diag.log | awk '/Modify/ {print $2}')
        getSnmac=$( echo "moxa" | $sshPass sudo -S fw_printenv 2>&1 | awk -F'=' '/(serialnumber|ethaddr)/ {printf "%s,", $2}')  # get SN/MAC 
        getIp=$( $sshPass ip a | awk '/inet [0-9]{3}\.[0-9]{2,3}\.[0-9]{2,3}\.[0-9]{2,3}/ {gsub("/[0-9]+$", "", $2); print $2}' )  # get SN/MAC 
        checkDate='2022-12-29'
        getPingng=$( $sshPass  grep "$checkDate.*PING" /home/moxa/ka_diag.log) # get SN/MAC 
        $getPingng 
        # echo $checkDate"," $getSnmac"," $getIp "," $getPingng >> /home/moxa/fwprintenv.log
    done
echo "finish"





        # if [ $count -gt 0 ]; then
      	# #p_checkCount="$(sshpass -p "$pwd" ssh -o stricthostkeychecking=no $cmd )"
      	# #echo "$(date +%F)"","$ip","$p_checkCount >> ./"$(date +%Y%m).csv"
        # 	echo $checkDate","$ip","$p_checkCount >> ./"$(date +%Y%m).csv"
        # else
      	# #echo "$(date +%F)"","$ip",-1" >> ./"$(date +%Y%m).csv"
      	#     echo $checkDate","$ip",-1" >> ./"$(date +%Y%m).csv"
        #  fi   

# mdTime="2023-01-03"
# checkDate=$(date -d "yesterday" '+%F')
# echo $checkDate



# if [ $mdtime == $checkDate ];then
#     # echo "相同"
# else
#     echo "不相同"
# fi









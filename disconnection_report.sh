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
        mdtime=$(stat ka_diag.log | awk '/Modify/ {print $2}') 
        checkDate=$(date -d "yesterday" '+%F') 
       # checkDate='2022-12-30'

      count=$(ping -c 2 $ip | grep from* | wc -l)
      if [ $count -gt 0 ]; then
##確認mqtt


##確認時間



## 確認PINGNG
        if [   $mdtime == $checkDate  ];then
          getSnmac=$( echo "$pwd" | $sshPass sudo -S fw_printenv 2>&1 | awk -F'=' '/(serialnumber|ethaddr)/ {printf "%s,", $2}')  # get SN/MAC 
          getPingng="$sshPass cat /home/moxa/ka_diag.log | awk '/$checkDate.*PING/ {print \$1,\$2}'"
        # $getPingng
          echo $($getPingng) , $getSnmac $ip,"PING NG"  >> /home/moxa/"$(date +%Y%m).csv" #NGTIME/SN,MAC/IP
       else
          echo $checkDate "," $ip "," "SF"  >> /home/moxa/"$(date +%Y%m).csv" # 無斷線
        fi
      else
          echo $checkDate","$ip",-1" >> ./"$(date +%Y%m).csv"
      fi
    done
echo "finish"

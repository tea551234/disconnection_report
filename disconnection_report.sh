#! /bin/bash
#2022_11_27 coding by willis
#2023_01_04 coding by teaya

file="/home/moxa/iptable.csv" #需定義iptable / pwd,ip,id
useKACMQTT="1"       #kill mqtt 使用:1 關閉:0

for line in $(cat $file); do
  nowDate=$(date "+%F %T")
  pwd=$(echo $line | cut -d"," -f 1)
  ip=$(echo $line | cut -d"," -f 2)
  id=$(echo $line | cut -d"," -f 3)
  sshPass="sshpass -p "$pwd" ssh -o PasswordAuthentication=yes moxa@"$ip" " #ssh連線
  log_file="/home/moxa/killmqtt.log"
  # checkDate=$(echo $(date -d "yesterday" '+%F'))
  count=$(ping -c 2 $ip | grep from* | wc -l)
  checkDate=$(date -d "yesterday" '+%F')

  # checkDate='2022-12-30' #測試用日期

  if [ $count -gt 0 ]; then
    ##確認mqtt
    mdtime=$($sshPass stat /home/moxa/ka_diag.log | awk '/Modify/ {print $2}')
    c_mqtt=$($sshPass ps -eo cmd,pid,%mem | grep ACMqtt | grep i | sed 's/\s+/ /g')
    mqttPid=$(echo $c_mqtt | awk '{print $4}')                          #PID
    mqttMEM=$(echo $c_mqtt | awk '{print $5}' | awk -F"." '{print $1}') #mem使用量
    # mqttMEM="6" #mem使用量 測試用
    while true; do
      if [ $mqttMEM -lt 5 ] || [ $useKACMQTT = "0" ]; then
        mqttSatus="$mqttMEM 小於 5% or 功能未開啟"
        break
      else
        mqttSatus="$mqttMEM 大於 5% "
        # echo "$pwd" | $sshPass sudo -S kill -9 $mqttPid
        break
      fi
    done

    ## 確認PINGNG
    if [ $mdtime = $checkDate ]; then
      getSnmac=$(echo "$pwd" | $sshPass sudo -S fw_printenv 2>&1 | awk -F'=' '/(serialnumber|ethaddr)/ {printf "%s,", $2}') # get SN/MAC
      getPingng="$sshPass cat /home/moxa/ka_diag.log | awk '/$checkDate.*PING/ {print \$1,\$2}'"
      # $getPingng
      echo $($getPingng) , $getSnmac $ip,"PING NG" >>/home/moxa/"$(date +%Y%m).csv" #NGTIME/SN,MAC/IP
    else
      echo $checkDate "," $ip "," "SF" "," $mqttSatus >>/home/moxa/"$(date +%Y%m).csv" # 無斷線
    fi

    ##確認時間
    # echo "$pwd" | $sshPass sudo -S date -s \"$nowDate\"
    # echo "$pwd" | $sshPass sudo -S hwclock -w
  else
    echo $checkDate","$ip",-1" >>./"$(date +%Y%m).csv"
  fi

done
echo "finish"

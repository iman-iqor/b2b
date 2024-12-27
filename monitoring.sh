#!/usr/bin/env bash

echo "#Architecture: $(uname -a)"
echo "#CPU Physical : $(lscpu | grep Socket | tr -s ' ' | cut -d ' ' -f 2)"
echo "#vCPU : $(nproc)"
ramstorage=$(free -m | grep 'Mem' | tr -s ' ' | cut -d ' ' -f 2)
ramused=$(free -m | grep 'Mem' | tr -s  ' ' | cut -d ' ' -f 3)
echo "#Memory Usage: ${ramused}/${ramstorage}Mb ($(echo "scale=2; ${ramused} * 100 / ${ramstorage}" | bc)%)"
disksize=$(echo "$(df -H | grep LVM  | tr -s ' ' | cut -d ' ' -f 2 | tr -d G | xargs | tr ' ' +)" | bc)
diskused=$(df -h --total | grep total | tr -s ' ' | cut -d ' ' -f 3 | tr -d G)
diskused2=$(echo "${diskused}*1024 / 1" | bc)
diskpourcentage=$(df -h --total | grep total | tr -s ' ' | cut -d ' ' -f 5)
echo  "#Disk Usage: ${diskused2}/${disksize}Gb (${diskpourcentage})"
cpurate=$(mpstat | grep all | tr -s ' ' | cut -d ' ' -f 13)
cpurate1=($(echo "100-${cpurate}" | bc)%)
echo "#CPU load : ${cpurate1}"
echo "#Last boot: $(who -b | tr -s ' ' | cut -d ' ' -f 4,5)"
echo "$(mount | grep -q "LVM" && echo "LVM USE: yes" || echo "LVM USE : no")"
echo "#Connection TCP : $(ss -t | grep ESTAB | wc -l) ESTABLISHED"
echo "#User log:$(who -q | head -n 1 | tr ' ' '\n' | sort -u | wc -l)"
echo "#Network: IP $(hostname -I) ($(ip addr | grep link/ether | tr -s ' ' | cut -d ' ' -f 3))"
echo "#Sudo : $(journalctl | grep COMMAND= | wc -l)"


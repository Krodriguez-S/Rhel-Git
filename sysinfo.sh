#vi /opt/scripts/system-info.sh



#!/bin/bash

echo "This script was aquired from https://www.2daygeek.com/bash-shell-script-view-linux-system-information/"

echo -e "-------------------------------System Information----------------------------"

echo -e "Hostname:\t\t"`hostname`

echo -e "uptime:\t\t\t"`uptime | awk '{print $3,$4}' | sed 's/,//'`

echo -e "Manufacturer:\t\t"`cat /sys/class/dmi/id/chassis_vendor`

echo -e "Product Name:\t\t"`cat /sys/class/dmi/id/product_name`

echo -e "Version:\t\t"`cat /sys/class/dmi/id/product_version`

echo -e "Serial Number:\t\t"`cat /sys/class/dmi/id/product_serial`

echo -e "Machine Type:\t\t"`vserver=$(lscpu | grep Hypervisor | wc -l); if [ $vserver -gt 0 ]; then echo "VM"; else echo "Physical"; fi`

echo -e "Operating System:\t"`hostnamectl | grep "Operating System" | cut -d ' ' -f5-`

echo -e "Kernel:\t\t\t"`uname -r`

echo -e "Architecture:\t\t"`arch`

echo -e "Processor Name:\t\t"`awk -F':' '/^model name/ {print $2}' /proc/cpuinfo | uniq | sed -e 's/^[ \t]*//'`

echo -e "Active User:\t\t"`w | cut -d ' ' -f1 | grep -v USER | xargs -n1`

echo -e "System Main IP:\t\t"`hostname -I`

echo ""

echo -e "-------------------------------CPU/Memory Usage------------------------------"

echo -e "Memory Usage:\t"`free | awk '/Mem/{printf("%.2f%"), $3/$2*100}'`

echo -e "Swap Usage:\t"`free | awk '/Swap/{printf("%.2f%"), $3/$2*100}'`

echo -e "CPU Usage:\t"`cat /proc/stat | awk '/cpu/{printf("%.2f%\n"), ($2+$4)*100/($2+$4+$5)}' |  awk '{print $0}' | head -1`

echo ""

echo -e "-------------------------------Disk Usage >80%-------------------------------"

df -Ph | sed s/%//g | awk '{ if($5 > 80) print $0;}'

echo ""



echo -e "-------------------------------For WWN Details-------------------------------"

vserver=$(lscpu | grep Hypervisor | wc -l)

if [ $vserver -gt 0 ]

then

	echo "$(hostname) is a VM"

else

	cat /sys/class/fc_host/host?/port_name

fi

echo ""



echo -e "-------------------------------Oracle DB Instances---------------------------"

if id oracle >/dev/null 2>&1; then

	/bin/ps -ef|grep pmon

then

else

	echo "oracle user does not exist on $(hostname)"

fi

echo ""



if (( $(cat /etc/*-release | grep -w "Oracle|Red Hat|CentOS|Fedora" | wc -l) > 0 ))

then

	echo -e "-------------------------------Package Updates-------------------------------"

	yum updateinfo summary | grep 'Security|Bugfix|Enhancement'

	echo -e "-----------------------------------------------------------------------------"

else

	echo -e "-------------------------------Package Updates-------------------------------"

	cat /var/lib/update-notifier/updates-available

	echo -e "-----------------------------------------------------------------------------"
echo "This Script was aquired from https://www.2daygeek.com/bash-shell-script-view-linux-system-information/"
fi

#!/bin/sh
interval=3
echo $1
i=$1
cpu_rate_file=./cpu_rate.csv
if [ -f ${cpu_rate_file} ]; then
    mv ${cpu_rate_file} ${cpu_rate_file}.`date +%m_%d-%H_%M_%S`.bak
fi
echo -n "cpu$i," >> ${cpu_rate_file}
echo -n "cpu_avg" >> ${cpu_rate_file}
echo "" >> ${cpu_rate_file}

while [ 1 ]
do
	start=$(cat /proc/stat | grep "cpu$i" | awk '{print $2" "$3" "$4" "$5" "$6" "$7" "$8}')
	start_idle=$(echo ${start} | awk '{print $4}')
	start_total=$(echo ${start} | awk '{printf "%.f",$1+$2+$3+$4+$5+$6+$7}')
	start=$(cat /proc/stat | grep "cpu " | awk '{print $2" "$3" "$4" "$5" "$6" "$7" "$8}')
	start_idle=$(echo ${start} | awk '{print $4}')
	start_total=$(echo ${start} | awk '{printf "%.f",$1+$2+$3+$4+$5+$6+$7}')
	sleep ${interval}

	end=$(cat /proc/stat | grep "cpu$i" | awk '{print $2" "$3" "$4" "$5" "$6" "$7" "$8}')
	end_idle=$(echo ${end} | awk '{print $4}')
	end_total=$(echo ${end} | awk '{printf "%.f",$1+$2+$3+$4+$5+$6+$7}')
	idle=`expr ${end_idle} - ${start_idle}`
	total=`expr ${end_total} - ${start_total}`
	idle_normal=`expr ${idle} \* 100`
	cpu_usage=`expr ${idle_normal} / ${total}`
	cpu_rate=`expr 100 - ${cpu_usage}`
	echo "The CPU$i Rate : ${cpu_rate}%"
	echo -n "${cpu_rate}," >> ${cpu_rate_file}

	end=$(cat /proc/stat | grep "cpu " | awk '{print $2" "$3" "$4" "$5" "$6" "$7" "$8}')
	end_idle=$(echo ${end} | awk '{print $4}')
	end_total=$(echo ${end} | awk '{printf "%.f",$1+$2+$3+$4+$5+$6+$7}')
	idle=`expr ${end_idle} - ${start_idle}`
	total=`expr ${end_total} - ${start_total}`
	idle_normal=`expr ${idle} \* 100`
	cpu_usage=`expr ${idle_normal} / ${total}`
	cpu_rate=`expr 100 - ${cpu_usage}`
	echo "The Average CPU Rate : ${cpu_rate}%"
	echo -n "${cpu_rate}" >> ${cpu_rate_file}
	echo "------------------"
	echo "" >> ${cpu_rate_file}
done

#!/bin/sh
interval=3
cpu_rate_file=./cpu_rate.csv
if [ -f ${cpu_rate_file} ]; then
    mv ${cpu_rate_file} ${cpu_rate_file}.`date +%m_%d-%H_%M_%S`.bak
fi
echo -n "cpu0,cpu1,cpu2,cpu3," >> ${cpu_rate_file}
echo -n "cpu_avg" >> ${cpu_rate_file}
echo "" >> ${cpu_rate_file}

while [ 1 ]
do
	start=$(cat /proc/stat | grep "cpu0" | awk '{print $2" "$3" "$4" "$5" "$6" "$7" "$8}')
	start_idle0=$(echo ${start} | awk '{print $4}')
	start_total0=$(echo ${start} | awk '{printf "%.f",$1+$2+$3+$4+$5+$6+$7}')
	
	start=$(cat /proc/stat | grep "cpu1" | awk '{print $2" "$3" "$4" "$5" "$6" "$7" "$8}')
	start_idle1=$(echo ${start} | awk '{print $4}')
	start_total1=$(echo ${start} | awk '{printf "%.f",$1+$2+$3+$4+$5+$6+$7}')
	
	start=$(cat /proc/stat | grep "cpu2" | awk '{print $2" "$3" "$4" "$5" "$6" "$7" "$8}')
	start_idle2=$(echo ${start} | awk '{print $4}')
	start_total2=$(echo ${start} | awk '{printf "%.f",$1+$2+$3+$4+$5+$6+$7}')
	
	start=$(cat /proc/stat | grep "cpu3" | awk '{print $2" "$3" "$4" "$5" "$6" "$7" "$8}')
	start_idle3=$(echo ${start} | awk '{print $4}')
	start_total3=$(echo ${start} | awk '{printf "%.f",$1+$2+$3+$4+$5+$6+$7}')
	
	start=$(cat /proc/stat | grep "cpu " | awk '{print $2" "$3" "$4" "$5" "$6" "$7" "$8}')
	start_idle=$(echo ${start} | awk '{print $4}')
	start_total=$(echo ${start} | awk '{printf "%.f",$1+$2+$3+$4+$5+$6+$7}')
	sleep ${interval}

	end=$(cat /proc/stat | grep "cpu0" | awk '{print $2" "$3" "$4" "$5" "$6" "$7" "$8}')
	end_idle=$(echo ${end} | awk '{print $4}')
	end_total=$(echo ${end} | awk '{printf "%.f",$1+$2+$3+$4+$5+$6+$7}')
	idle=`expr ${end_idle} - ${start_idle0}`
	total=`expr ${end_total} - ${start_total0}`
	idle_normal=`expr ${idle} \* 100`
	cpu_usage=`expr ${idle_normal} / ${total}`
	cpu_rate=`expr 100 - ${cpu_usage}`
	echo "The CPU0 Rate : ${cpu_rate}%"
	echo -n "${cpu_rate}," >> ${cpu_rate_file}
	
	end=$(cat /proc/stat | grep "cpu1" | awk '{print $2" "$3" "$4" "$5" "$6" "$7" "$8}')
	end_idle=$(echo ${end} | awk '{print $4}')
	end_total=$(echo ${end} | awk '{printf "%.f",$1+$2+$3+$4+$5+$6+$7}')
	idle=`expr ${end_idle} - ${start_idle1}`
	total=`expr ${end_total} - ${start_total1}`
	idle_normal=`expr ${idle} \* 100`
	cpu_usage=`expr ${idle_normal} / ${total}`
	cpu_rate=`expr 100 - ${cpu_usage}`
	echo "The CPU1 Rate : ${cpu_rate}%"
	echo -n "${cpu_rate}," >> ${cpu_rate_file}
	
	end=$(cat /proc/stat | grep "cpu2" | awk '{print $2" "$3" "$4" "$5" "$6" "$7" "$8}')
	end_idle=$(echo ${end} | awk '{print $4}')
	end_total=$(echo ${end} | awk '{printf "%.f",$1+$2+$3+$4+$5+$6+$7}')
	idle=`expr ${end_idle} - ${start_idle2}`
	total=`expr ${end_total} - ${start_total2}`
	idle_normal=`expr ${idle} \* 100`
	cpu_usage=`expr ${idle_normal} / ${total}`
	cpu_rate=`expr 100 - ${cpu_usage}`
	echo "The CPU2 Rate : ${cpu_rate}%"
	echo -n "${cpu_rate}," >> ${cpu_rate_file}
	
	
	end=$(cat /proc/stat | grep "cpu3" | awk '{print $2" "$3" "$4" "$5" "$6" "$7" "$8}')
	end_idle=$(echo ${end} | awk '{print $4}')
	end_total=$(echo ${end} | awk '{printf "%.f",$1+$2+$3+$4+$5+$6+$7}')
	idle=`expr ${end_idle} - ${start_idle3}`
	total=`expr ${end_total} - ${start_total3}`
	idle_normal=`expr ${idle} \* 100`
	cpu_usage=`expr ${idle_normal} / ${total}`
	cpu_rate=`expr 100 - ${cpu_usage}`
	echo "The CPU3 Rate : ${cpu_rate}%"
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

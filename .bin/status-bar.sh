#!/usr/bin/env bash

function display_disk {
	echo -e "+@fn=1;\uf0a0 +@fn=0;$(df -h | awk '$6=="/"{ print "(free:"$4")(used:"$3"/"$2" - "$5")"}')"
}

function display_mem {
	echo -e "+@fn=1;\uf85a +@fn=0;$(free -h | awk '$1=="Mem:"{ print "(used:"$3")/"$2 }')"
}

function display_net {
	ping 1.1.1.1 -c 1 > /dev/null

	if [ $? -eq 0 ]; then
		echo -e "+@fn=1;\ufbf2;+@fn=0;"
	else
		echo -e "+@fn=1;\uf65a+@fn=0;"
	fi
}

function display_battery {
	POWER_NODE=/sys/class/power_supply
	BAT_NODE=${POWER_NODE}/BAT0
	# AC_NODE=${POWER_NODE}/AC  # Others
	AC_NODE=${POWER_NODE}/ADP1  # Macbook Pro

	if [ -d ${BAT_NODE} ] && [ -d ${AC_NODE} ]; then
		bat_level=$(cat ${BAT_NODE}/capacity)
		ac_status=$(cat ${AC_NODE}/online)

		if [ "${ac_status}" -eq 1 ]; then
			ac_status=" \uf583"
		else
			ac_status=" \uf242"
		fi

		echo -e "${bat_level}%${ac_status}"
	else
		echo -e "+@fn=1;\uf240+@fn=0;"
	fi
}

while :; do
	echo \
		$(display_disk) / \
		$(display_mem) / \
		$(display_net) / \
		$(display_battery)
	sleep 5
done

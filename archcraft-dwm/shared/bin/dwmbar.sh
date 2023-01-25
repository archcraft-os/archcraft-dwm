#!/usr/bin/bash

interval=0

#^b#1e222a^ <- no background color

## Cpu Info
cpu_info() {
	cpu_load=$(grep -o "^[^ ]*" /proc/loadavg)

	printf "^c#3b414d^ ^b#7ec7a2^ 󰻠"
	printf "^c#abb2bf^ ^b#353b45^ $cpu_load"
}

## Memory
memory() {
	printf "^c#C678DD^^b#1e222a^  󰍛 $(free -h | awk '/^Mem/ { print $3 }' | sed s/i//g) "
}

## Wi-fi
wlan() {
	case "$(cat /sys/class/net/w*/operstate 2>/dev/null)" in
		up) printf "^c#3b414d^^b#7aa2f7^  ^d^%s" " ^c#7aa2f7^Connected " ;;
		down) printf "^c#3b414d^^b#E06C75^ 睊 ^d^%s" " ^c#E06C75^Disconnected " ;;
	esac
}

## Time
clock() {
	printf "^c#1e222a^^b#668ee3^  "
	printf "^c#1e222a^^b#7aa2f7^ $(date '+%a, %d/%m %H:%M') "
}

## System Update
updates() {
	updates=$(checkupdates | wc -l)

	if [ -z "$updates" ]; then
		printf "^c#98C379^  Updated"
	else
		printf "^c#98C379^  $updates"" updates"
	fi
}

## Battery Info
battery() {
	BAT=$(upower -i `upower -e | grep 'BAT'` | grep 'percentage' | cut -d':' -f2 | tr -d '%,[:blank:]')
	AC=$(upower -i `upower -e | grep 'BAT'` | grep 'state' | cut -d':' -f2 | tr -d '[:blank:]')

	if [[ "$AC" == "charging" ]]; then
		printf "^c#E49263^  $BAT%%"
	elif [[ "$AC" == "fully-charged" ]]; then
		printf "^c#E06C75^  Full"
	else
		if [[ ("$BAT" -ge "0") && ("$BAT" -le "20") ]]; then
			printf "^c#E98CA4^  $BAT%%"
		elif [[ ("$BAT" -ge "20") && ("$BAT" -le "40") ]]; then
			printf "^c#E98CA4^  $BAT%%"
		elif [[ ("$BAT" -ge "40") && ("$BAT" -le "60") ]]; then
			printf "^c#E98CA4^  $BAT%%"
		elif [[ ("$BAT" -ge "60") && ("$BAT" -le "80") ]]; then
			printf "^c#E98CA4^  $BAT%%"
		elif [[ ("$BAT" -ge "80") && ("$BAT" -le "100") ]]; then
			printf "^c#E98CA4^  $BAT%%"
		fi
	fi
}

## Brightness
brightness() {
	LIGHT=$(printf "%.0f\n" `light -G`)

	if [[ ("$LIGHT" -ge "0") && ("$LIGHT" -le "25") ]]; then
		printf "^c#56B6C2^  $LIGHT%%"
	elif [[ ("$LIGHT" -ge "25") && ("$LIGHT" -le "50") ]]; then
		printf "^c#56B6C2^  $LIGHT%%"
	elif [[ ("$LIGHT" -ge "50") && ("$LIGHT" -le "75") ]]; then
		printf "^c#56B6C2^  $LIGHT%%"
	elif [[ ("$LIGHT" -ge "75") && ("$LIGHT" -le "100") ]]; then
		printf "^c#56B6C2^  $LIGHT%%"
	fi
}

mic() {
	ID="`pulsemixer --list-sources | grep 'Default' | cut -d',' -f1 | cut -d' ' -f3`"
	if [[ `pulsemixer --id $ID --get-mute` == 0 ]]; then
	  printf "^c#ffffff^^b#d81b60^ 󰍬 "
	  printf "^c#abb2bf^^b#353b45^ ON "
	else
	  printf "^c#ffffff^^b#555555^ 󰍭 "
	  printf "^c#abb2bf^^b#353b45^ OFF "
	fi
	  printf "^b#1e222a^"
}

currentSignal=1
maxChars=30
spotify() {
	artist=`playerctl -p spotify metadata --format '{{artist}}:'`
	title=`playerctl -p spotify metadata --format '{{title}}'`
	#album=`playerctl -p spotify metadata --format ' <{{album}}>'`
  titleSize=${#title}

  if [[ $titleSize -le $maxChars ]]; then
	printf "^c#aed581^^b#1e222a^ 󰎈 $artist"
	printf "^c#abb2bf^ $title"
    return
  fi

  endIndex=$((titleSize - maxChars))
  mirrorBoundary=$((endIndex * 2))
  currentVirtualIndex=$((interval % mirrorBoundary))
  isInReverseDirection=$((currentVirtualIndex / endIndex))

  currentStart=$currentVirtualIndex
  if [[ isInReverseDirection -eq 0 ]]; then
    currentStart=$currentVirtualIndex
  else
    currentStart=$((mirrorBoundary - currentVirtualIndex))
  fi

  trimmedTitle=${title:currentStart:maxChars}

	printf "^c#aed581^^b#1e222a^ 󰎈 $artist"
	printf "^c#abb2bf^ $trimmedTitle"
}

## Main
while true; do
  #[ "$interval" == 0 ] || [ $(("$interval" % 3600)) == 0 ] && updates=$(updates)
  interval=$((interval + 1))

  sleep 0.15 && xsetroot -name "$(spotify) $(mic) $(cpu_info) $(memory) $(clock)"
done

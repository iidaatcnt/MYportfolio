#!/usr/bin/env bash
# Depends on: 
#   - notify-send
#   - paplay
# base stolen from: http://snipplr.com/view/39697/a-simple-timer-to-apply-the-pomodoro-technique/
# 

scriptname=$(basename $0 .sh)
scriptvers='0.1'

# select a sound here
sound="/home/xananax/fallbackring.ogg"

minute=60
m_resting=5
m_working=25
m_cycles=4
bar_width=30
bar_char="."
pause_char=' '
pause_char_display="$pause_char"
if [[ $pause_char_display = ' ' ]]; then pause_char_display='space';fi;
progress_line="# %s (session %s): time remaining: %s ([$pause_char_display] to pause)\n %s (%d%%)\033[1A\r"
interrupt_line="# Paused for %s, ([$pause_char_display] to resume)\r"
start_line="Session %d of %d started for %dmn (cycle %d)"
pause_line="Session done! take a breath for %smn"
long_pause_line="Yahooooooooo!!!!! Take a break! rest for %smn"
start_new_cycle_line="Starting cycle %d (%d sessions)"


function convertsecs() {

	((h=${1}/3600))
	((m=(${1}%3600)/60))
	((s=${1}%60))
	printf "%02d:%02d:%02d\n" $h $m $s

}


function progress_bar() {

	value=$1
	max=$2
	num=$(( value * bar_width / max ))
	bar=
	if [ $num -gt 0 ]; then
		bar=$(printf "%0.s${bar_char}" $(seq 1 $num))
	fi
	line=$(printf "%s [%-${bar_width}s]" "$title" "$bar")
	echo -en "${line}"

}

function starting_dialog(){

	zen --forms --title "$scriptname - $scriptvers" \
	--separator=" " \
	--text="Starting Tomatoe Timer" \
	--add-entry="working time (default: $m_working)" \
	--add-entry="resting time (default: $m_resting)"
}
 
function tomatoe_timer(){
	TASK=$1
	LIMIT=$2
	CYCLE=$3
	COUNT=0
	PERCENT=0
	PAUSE_TIMER=0
	pause=""
	unpause=""
	(
		while [ $COUNT -lt $LIMIT ]; do
			if [[ $pause == "$pause_char" ]];then
				echo ""
				while [[ $pause == "$pause_char" ]]; do
					if [[ $unpause == "$pause_char" ]]; then
						pause=""
						unpause=""
						echo ""
					else
						line=$(printf "$interrupt_line" "$(convertsecs $PAUSE_TIMER)")
						echo -ne "$line"
						read -d'' -s -n1 -t1 -r
						unpause="$REPLY"
						let PAUSE_TIMER=$PAUSE_TIMER+1
					fi
				done
			fi
			PERCENT=$((($COUNT*100)/$LIMIT))
			PROGRESS=`progress_bar $COUNT $LIMIT`
			line=$(printf "$progress_line" "$TASK" "$CYCLE" "$(convertsecs $(($LIMIT-$COUNT)))" "$PROGRESS" "$PERCENT")
			echo -ne "$line"
			let COUNT=$COUNT+1
			read -d'' -s -n1 -t1 -r
			pause="$REPLY"
		done
	)
	echo ""
	echo ""
	return $?
}
 
function zen_alert(){

	play "$audio_warning" & # Decomment if you want a sound warning.
	zen --title="Cycles: $count_cycle" --question \
	--text="Time to $1 has Finished!\nShall I Continue?"
	return $?
}
 
function notify(){
	message=$1
	icon=$2
	shift
	shift
	line=$(printf "$message" $@)
	which notify-send >/dev/null && notify-send "$line" -i "$icon"
	echo ""
	echo "$line"
	echo ""
	which paplay >/dev/null && paplay "$sound"
}

function sep() {
	echo ""
	echo "---------------------------------------------"
}

function __main__(){

	count_cycle=1
	current_cycles=0
	long_pause=0

	read -e -p "Session time (minutes): " -i "$m_working" m_working
	read -e -p "Short break time (minutes): " -i "$m_resting" m_resting
	read -e -p "Number of sessions in a cycle: " -i "$m_cycles" m_cycles
	read -e -p "Long break time (minutes): " -i "$((m_resting*m_cycles))" m_resting_long

	s_working=$(($m_working*$minute))
	s_resting=$(($m_resting*$minute))
	s_resting_long=$(($m_resting_long*$minute))

	sep
	notify "$start_new_cycle_line" clock $count_cycle $m_cycles

	while true
	do
		notify "$start_line" clock $(($current_cycles+1)) $m_cycles $m_working $count_cycle
		tomatoe_timer "In session"  $s_working $count_cycle
		let current_cycles=$current_cycles+1
		if [[ "$current_cycles" -eq "$m_cycles" ]]; then
			long_pause=1
			current_cycles=0
		fi
		if [[ "$long_pause" -eq 1 ]]; then
			notify "$long_pause_line" face-cool $m_resting_long
			tomatoe_timer "Long Pause" $s_resting_long $count_cycle
			sep
			notify "$start_new_cycle_line" clock $count_cycle $m_cycles
			long_pause=0
		else
			notify "$pause_line" face-laugh $m_resting
			tomatoe_timer "Pause" $s_resting $count_cycle
		fi
		let count_cycle=$count_cycle+1
	done
}
 

__main__

#!/usr/bin/env bash
#
# adapted from this charm CLI blog post:
#
# https://charm.sh/blog/kamoji-generator/

if ! test -x "$(command -v skate)"; then
	echo "missing required dependency: skate"
	exit 1
fi

if ! test -x "$(command -v gum)"; then
	echo "missing required dependency: gum"
	exit 1
fi

notif() {
	notify-send "$kaomoji copied to clipboard!"
}

logic() {
	# check for existing DB
	check="$(skate list @kaomoji)"

	if [[ $check == "" ]]; then
		echo "please install kaomojis: kaomoji install"
		exit 1
	fi
}

default() {
	logic
	
	# print list to select or search for a kaomoji by name
	kaomoji="$(skate list @kaomoji | gum filter | sed -e 's/^\w*\ *//')"
	if [[ "$kaomoji" == "" ]]; then
		exit 1
	fi

	choice=$(echo "$kaomoji")
	if [[ "$choice" == "" ]]; then
		exit 1
	fi

	if command -v xsel &> /dev/null; then
		printf '%s' "$choice" | xclip -sel clip # X11
		notif
	elif command -v pbcopy &> /dev/null; then
		printf '%s' "$choice" | pbcopy # macOS
		notif
	else
		printf 'Here you go: %s\n' "$choice" | lolcat -p 0.5
		notif
		exit 0
	fi

	printf 'Copied %s to the clipboard\n' "$choice" | lolcat -p 0.5
	notif
}

menu() {
	pick=$(skate list "@kaomoji" | dmenu -i -c -l 10)

	if [[ "$pick" == "" ]]; then
		exit 0
	fi
	
	printf "$pick" | sed -e 's/^\w*\ *//' | tr -d '[:blank:]' | xclip -sel clip | notif
}

case "$1" in
	"")
		default
		;;
	"-h" | "--help" | "help")
        printf 'pick from a list of kaomojis! \n\n'
        printf 'Usage: %s [kind]\n' "$(basename "$0")"
        exit 1
        ;;
    "install" | "add")
    	echo "installing skate DB" | lolcat -p 0.5
    	source install-db.sh
    	clear
    	;;
    "dmenu" | "menu")
    	menu
    	;;
esac

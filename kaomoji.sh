#!/usr/bin/env bash
#
# adapted from this charm CLI blog post:
#
# https://charm.sh/blog/kamoji-generator/

# print basic help
case "$1" in
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
esac

if ! test -x "$(command -v skate)"; then
	echo "missing required dependency: skate"
	exit 1
fi

if ! test -x "$(command -v gum)"; then
	echo "missing required dependency: gum"
	exit 1
fi

# check for existing DB
check="$(skate list @kaomoji)"

if [[ $check == "" ]]; then
	echo "please install kaomojis: kaomoji install"
	exit 1
fi

# print list to select or search for a kaomoji by name
kaomoji="$(skate list @kaomoji | gum filter | sed -e 's/^\w*\ *//')"
if [[ $kaomoji == "" ]]; then
	exit 1
fi

choice="$(echo $kaomoji)"
if [[ $choice == "" ]]; then
	exit 1
fi

notif() {
	notify-send "$kaomoji copied to clipboard!"
}

# If xsel (X11) or pbcopy (macOS) exists, copy to the clipboard. If not, just
# print the Kaomoji.
if command -v xsel &> /dev/null; then
	printf '%s' "$choice" | xclip -sel clip | notif # X11
elif command -v pbcopy &> /dev/null; then
	printf '%s' "$choice" | pbcopy | notif # macOS
else
	# We can't copy, so just print it out.
	printf 'Here you go: %s\n' "$choice" | lolcat -p 0.5 | notif
	exit 0
fi

# We're done!
printf 'Copied %s to the clipboard\n' "$choice" | lolcat -p 0.5 | notif

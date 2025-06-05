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

# If xsel (X11) or pbcopy (macOS) exists, copy to the clipboard. If not, just
# print the Kaomoji.
if command -v xsel &> /dev/null; then
	printf '%s' "$choice" | xclip -sel clip # X11
elif command -v pbcopy &> /dev/null; then
	printf '%s' "$choice" | pbcopy # macOS
else
	# We can't copy, so just print it out.
	printf 'Here you go: %s\n' "$choice" | lolcat -p 0.5
	exit 0
fi

# We're done!
printf 'Copied %s to the clipboard\n' "$choice" | lolcat -p 0.5

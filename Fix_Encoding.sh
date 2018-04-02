#!/bin/bash
if [ "$#" -gt 0 ]; then
	if [[ ! -e "$1" ]]; then
		echo "$1: No such directory please try again"
		exit 1
	fi
        cd $1
        for f in *.srt; do
                [ -f "$f" ] || continue
		if [ $(file -bi "$f" | awk '{ print $2 }') != "charset=utf-8" ]; then
			iconv -f Windows-1255 -t utf-8 "$f" > $f.tmp
			mv "$f" "$f.orig"
			mv "$f.tmp" "$f"
		fi
        done
	while true ; do
		printf 'What To Do With The Origiinal Files? (D=Delete, B=Backup, N=Nothing): '
		read -r ans
		case $ans in
		D|d)
			for d in *.orig; do
				[ -f "$d" ] || continue
				rm -f "$d"
			done
			echo "Deleted all original files"
			break
			;;
		
		B|b)
			if [[ ! -e 'Original_Files' ]]; then
				mkdir 'Original_Files'
			fi
			for b in *.orig; do
				[ -f "$b" ] || continue
				#name=$(basename $b .orig)
				mv $b "Original_Files/${b%.*}"
			done
			echo "Moved all original files to Original_Files folder"
			break
			;;
		
		N|n)
			echo "All files are where you left them"
			break
			;;	
		*)
			echo "You picked a non exiting option try again"
		esac
	done
	echo "Done"
	# if [ "$ans" == "y" ] || [ "$ans" == "Y" ]; then
	# 	for o in *.old; do
	# 	[ -f "$o" ] || continue
	# 	rm -f $o
	# 	done
	# fi
else
        echo "Usage ./Fix_Encoding.sh <path to folder>"
fi



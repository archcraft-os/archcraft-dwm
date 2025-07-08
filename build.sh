#!/usr/bin/env bash

## Copyright (C) 2020-2025 Aditya Shakya <adi1090x@gmail.com>

## Script Termination
exit_on_signal_SIGINT () {
    { printf "\n\n%s\n" "Script interrupted." 2>&1; echo; }
    exit 0
}

exit_on_signal_SIGTERM () {
    { printf "\n\n%s\n" "Script terminated." 2>&1; echo; }
    exit 0
}

trap exit_on_signal_SIGINT SIGINT
trap exit_on_signal_SIGTERM SIGTERM

# Build packages
build_pkg () {
	echo -e "\nBuilding Package ${1} - \n"
	cd ${1} && makepkg -sc

	if [[ "$1" == "archcraft-st" ]]; then
		rm *.tar.gz
	fi
	
	RDIR='../../../pkgs/x86_64'
	if [[ -d "$RDIR" ]]; then
		mv -f *.pkg.tar.zst "$RDIR"
		echo -e "\nPackage moved to Repository.\n[!] Don't forget to update the database.\n"
	fi
	cd -
}

# Execute
build_pkg archcraft-dwm
build_pkg archcraft-st

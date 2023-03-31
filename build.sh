#!/usr/bin/env bash

## Copyright (C) 2020-2023 Aditya Shakya <adi1090x@gmail.com>

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
	cd ${1}
  rm -r pkg src *.pkg.tar.zst
  makepkg -sc

	if [[ "$1" == "archcraft-st" ]]; then
		rm *.tar.gz
	fi
	
	cd -
}

# Execute
build_pkg archcraft-dwm
build_pkg archcraft-st

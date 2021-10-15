#!/usr/bin/env bash

## Copyright (C) 2020-2021 Aditya Shakya <adi1090x@gmail.com>
## Everyone is permitted to copy and distribute copies of this file under GNU-GPL3

## Launch Applications

if [[ "$1" == "-f" ]]; then
	thunar
elif [[ "$1" == "-e" ]]; then
	geany
elif [[ "$1" == "-w" ]]; then
	firefox
fi

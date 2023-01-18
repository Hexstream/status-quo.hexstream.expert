#!/bin/bash

function cleanup() {
    tput cnorm
}

trap cleanup EXIT


tput civis
clear
echo $1
sleep infinity

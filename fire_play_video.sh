#!/bin/bash
# Script to play video on Raspberry Pi
# (C) 2014 Mike Roseman
# MIT LICENSE
#
#set -x

### Variables
# set pathname
#SCRIPTDIR=.  #If running for current directory
SCRIPTDIR=/home/pi/pi_fire_sequence

#Path to video to play
VIDEO=/home/pi/pi_fire_sequence/See_the_Fnords.mp4
###

#Clear screen (oddly this leaves bars on screen during first video played)
#Should this run as sudo or user?
#sudo sh -c "setterm -term xterm -cursor off -clear -blank 0 -powersave off -powerdown 0 >/dev/tty1"
sudo sh -c "setterm -term xterm -cursor off -clear -blank 0 -powerdown 0 >/dev/tty1"

#Play video in background
#   It says hdmi, but this also works for my analog output
# Do I need to do the FIFO thing here, since we aren't controlling playback?
omxplayer -p -o local "$VIDEO" >/dev/null 2>&1 &

# Clear screen again?

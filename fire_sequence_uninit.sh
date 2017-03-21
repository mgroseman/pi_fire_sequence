#!/bin/bash
# Script to uninitialize GPIOs 
# (C) 2014 Mike Roseman
# MIT LICENSE
#
# This needs to run as root 
#   - or the "echo"s need to be done as sudo
#   - or the /sys files ownership need to be changed to the running user
# Since you are running as root, be sure to call the subscripts as the relevant users
#
# $Id: fire_sequence_init.sh,v 1.1 2014/08/25 02:16:54 pi Exp pi $

# Debugging (will print each line executed, if uncommented)
#set -x

# set pathname
#SCRIPTDIR=.  #If running for current directory
SCRIPTDIR=/home/pi/pi_fire_sequence

### Load variables 
. $SCRIPTDIR/FIRE_SEQUENCE.env
###

###  Initialize GPIO tasks
for GPIO_NUM in $SEQ  #Loop down each GPIO pin
do
  # Setup a GPIO as an OUTPUT and to the default value
  #rpio --setoutput=${GPIO_NUM}:${DEFAULT_HIGHLOW}
  echo "$GPIO_NUM" > /sys/class/gpio/unexport
done  #Continue loop
###

### Any ending tasks here
###

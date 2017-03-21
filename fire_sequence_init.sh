#!/bin/bash
# Script to setup GPIOs for the next scripts
# (C) 2014 Mike Roseman
# MIT LICENSE
#
# This needs to run as root "sudo watch_buttons.sh"
#   - or the "echo"s need to be done as sudo
#   - or the /sys files ownership need to be changed to the running user
# Since you are running as root, be sure to call the subscripts as the relevant users
#

# Debugging (will print each line executed, if uncommented)
#set -x

# set pathname
SCRIPTDIR=/home/pi/pi_fire_sequence

### Load variables 
. $SCRIPTDIR/FIRE_SEQUENCE.env
###

###  Initialize GPIO tasks
for GPIO_NUM in $SEQ  #Loop down each GPIO pin
do
  # Setup a GPIO as an OUTPUT and to the default value
  #Old way...took too much time per command
  #rpio --setoutput=${GPIO_NUM}:${DEFAULT_HIGHLOW}
  # Note, this first command will generate a write error if already done.  ignore.
  echo "$GPIO_NUM" > /sys/class/gpio/export
  echo "out" > /sys/class/gpio/gpio${GPIO_NUM}/direction
  echo "${DEFAULT_HIGHLOW}" > /sys/class/gpio/gpio${GPIO_NUM}/value
done  #Continue loop
###

### Any ending tasks here
###

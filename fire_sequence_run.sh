#!/bin/bash
# Script to set off GPIOs in sequence
# (C) 2014 Mike Roseman
# MIT LICENSE
#
# This needs to run as root "sudo watch_buttons.sh"
#   - or the "echo"s need to be done as sudo
#   - or the /sys files ownership need to be changed to the running user
# Since you are running as root, be sure to call the subscripts as the relevant users
#
#$Id: fire_sequence_run.sh,v 1.4 2014/08/26 02:41:53 pi Exp pi $

# Debugging (will print each line executed, if uncommented)
#set -x

# set pathname
#SCRIPTDIR=.  #If running for current directory
SCRIPTDIR=/home/pi/pi_fire_sequence

### Load variables
. $SCRIPTDIR/FIRE_SEQUENCE.env
###

### Other variables
LOCKFILE=$SCRIPTDIR/fire_sequence.lock

### Make sure we aren't already running
if [ -e $LOCKFILE ] ; then
 #echo "Already running" 
 exit 255
fi
###

### If this script terminates in any place, remove lockfile
# This is a trap, so if this script receives any of these signals, it will run this
trap "rm $LOCKFILE ; exit" SIGHUP SIGINT SIGQUIT SIGTERM
###

###  Otherwise, create lockfile to show we are running
touch $LOCKFILE
###

## Main loop to trigger relays

#Run this twice to get through video
for LOOP in 1 2
do
  #Turn relays on
  for GPIO_NUM in $SEQ  #Loop down each GPIO pin
  do
    # Turn on GPIO
    echo "Setting GPIO $GPIO_NUM to $ON" > /dev/null #Just so the set -x shows me where I am
    echo "${ON}" > /sys/class/gpio/gpio${GPIO_NUM}/value

    # Wait
    sleep $TIMEON  

  done  # Continue loop

  # Delay before lights off 
  sleep $TIME_AFTERLIT

  #Turn relays off
  for GPIO_NUM in $SEQ  #Loop down each GPIO pin
  do
    # Turn off GPIO
    echo "Setting GPIO $GPIO_NUM to $OFF" > /dev/null #Just so the set -x shows me where I am
    echo "${OFF}" > /sys/class/gpio/gpio${GPIO_NUM}/value
  done

  # Delay before  next loop
  sleep $TIME_BTWN
done  #End main LOOP
###

### Any ending tasks here
###

### Remove lockfile
rm $LOCKFILE
###

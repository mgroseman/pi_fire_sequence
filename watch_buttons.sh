#!/bin/bash
# Script to watch Raspberry Pi buttons and take actions
# (C) 2014 Mike Roseman
# MIT LICENSE
#
# This needs to run as root "sudo watch_buttons.sh"
#   - or the "echo"s need to be done as sudo
#   - or the /sys files ownership need to be changed to the running user
# Since you are running as root, be sure to call the subscripts as the relevant users
#
# $Id: watch_buttons.sh,v 1.4 2014/08/26 02:40:41 pi Exp pi $

# Debugging (will print each line executed, if uncommented)
##set -x

### Variables
# set pathname
#SCRIPTDIR=.  #If running for current directory
SCRIPTDIR=/home/pi/pi_fire_sequence

#Set GPIOs to watch
GPIOS_TO_WATCH="17"

# User to run subscripts as
RUNAS="pi"

### Initialize
#
#Create PID file so init script can kill me  $0 = my name
PIDFILE=/var/run/`basename $0`.pid
# This is a trap, so if this script receives any of these signals, it will run this
trap "rm $PIDFILE ; exit" SIGHUP SIGINT SIGQUIT SIGTERM
# Create PIDFILE.   $$ is = to my PID
echo $$ > $PIDFILE

#
# Run script to set output GPIOs for relays 
sudo $SCRIPTDIR/fire_sequence_init.sh

#Setup GPIO devices for reading
for GPIO in $GPIOS_TO_WATCH
do
  echo "$GPIO" > /sys/class/gpio/export
  echo "in" > /sys/class/gpio/gpio${GPIO}/direction
done
###

### Main loop
while true  #Loop forever!!!
do
 for GPIO in $GPIOS_TO_WATCH
 do
  VALUE=`cat /sys/class/gpio/gpio${GPIO}/value`
  if [ "$VALUE" -eq 0 ]    #button pressed
  then  
    ### Do something based on which GPIO we are looking at
    #   Please change the #) lines to the GPIOs you are using
    case $GPIO in
        17) #GPIO17
           #echo "GPIO17 pressed"
           # Run video script
           sudo -u $RUNAS $SCRIPTDIR/fire_play_video.sh
           # Run fire script
           sudo $SCRIPTDIR/fire_sequence_run.sh
           ;;
        ### 18) #GPIO18
        ###   #echo "GPIO18 pressed"
        ###   ;;
    esac
    ###
  fi
  sleep .1  #wait a split second to slow down probing loop
 done
done
###

### Clean up  #Hmmm...will never get here.  Make this a TRAP
 ### Clean up GPIOS
 for GPIO in $GPIOS_TO_WATCH
 do
  echo "$GPIO" > /sys/class/gpio/unexport
 done
 ###
###
# 

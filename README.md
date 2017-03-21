These scripts were created for a display exhibit at a museum

What happens:
After a button is pushed:
 - Video is played on a projector
 - While video is playing, a sequence of lights turn on to illuminate display items along the wall.

Build:
I'll have to put up a schematic later, but the basic components are:
- Button, goes to ground, I think.
- Sainsmart relay board, controlling 120V on the hot-side
- Video projector / display attached to Pi video out (and sound)

Software setup:
NOTE: Before you play with real voltage, test your setup well.  If Pi crashes, it might leave power on, so don't use to control a heater with no-one present.

1)  Modify this variable in all scripts, which tells them where they are located: (not the greatest method)
  SCRIPTDIR=/home/pi/pi_fire_sequence   (or whereever you put these)

2) Make scripts executable
   $ chmod 755 fire_*.sh

3) Look at contents of FIRE_SEQUENCE.env and change default variables in your favorite editor 
     Important variables:  GPIOS_TO_WATCH = GPIO#, not PIN#.
     Can handle multiple buttons, or just one.
     You also need to change the #) lines under "case" to the GPIOs you are using
     This script needs to run as root.  Either via "sudo watch_buttons.sh" or during boot.   But it will run the scripts it calls as RUNAS user, for more security.
     The script never ends!  It will look forever.

4) Modify fire_play_video.sh to add the video you want to play:
     Variable:  VIDEO = location of video to play
     Uses omxplayer, which plays accelerated video using the hardware decoding on the pi

5)  Boot startup script (init.d script at the moment, systemd in future verion)
    Use this template file: pi_fire_sequence.initd
      Modify these variables:  SCRIPTDIR 
      Copy into place:
      # sudo cp pi_fire_sequence.initd /etc/init.d/pi_fire_sequence
      # sudo ln -s ../init.d/pi_fire_sequence /etc/rc2.d/S99pi_fire_sequence
      If you want to stop it from starting on boot:
      # sudo rm /etc/rc2.d/S99pi_fire_sequence

6)
      If you want to start/stop the watch_buttons.sh daemon on demand, run these:
      # sudo /etc/init.d/pi_fire_sequence start
      # sudo /etc/init.d/pi_fire_sequence stop
      Or you can just run the pi_fire_sequence.initd script with the same options
      

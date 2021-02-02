#!/bin/bash
#Make sure to enable nvidia-xconfig --cool-bits=4


#This new script works with version 378.13 driver
#Old script is not functional (on Arch, at least)
#Changed up some options and flags for nvidia-settings
#Added some comments for clarity, in case other people want to make improved forks

#enable headless mode 
#request lightdm installed - apt install --no-install-recommends xorg lightdm for debian/ubuntu
headless=true
verbose=false

if [ "$headless" = true ] ; then
    export DISPLAY=:0 XAUTHORITY=/run/lightdm/jan/xauthority
fi

#Enable user defined fancontrol for all gpu
nvidia-settings -a "GPUFanControlState=1"

while true
do

    #gpu index
    i=0

    #Get GPU temperature of all cards
    for gputemp in $(nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader);do
    
    if [ "$verbose" = true ] ; then
        echo "gpu ${i} temp ${gputemp}"; 
    fi

        #Note: you need to set the minimum fan speed to a non-zero value, or it won't work
        #This fan profile is being used in my GTX580 (Fermi). Change it as necessary

        #If temperature is between X to Y degrees, set fanspeed to Z value
        case "${gputemp}" in
                0[0-9])
                        newfanspeed="0"
                        ;;
                1[0-9])
                        newfanspeed="0"
                        ;;
                2[0-9])
                        newfanspeed="0"
                        ;;
                3[0-9])
                        newfanspeed="0"
                        ;;
                4[0-3])
                        newfanspeed="15"
                        ;;
                4[4-7])
                        newfanspeed="20"
                        ;;
                4[8-9])
                        newfanspeed="25"
                        ;;
                5[0-2])
                        newfanspeed="30"
                        ;;
                5[3-4])
                        newfanspeed="40"
                        ;;
                5[5-6])
                        newfanspeed="50"
                        ;;
                5[7-9])
                        newfanspeed="60"
                        ;;
                6[0-2])
                        newfanspeed="80"
                        ;;
                6[3-5])
                        newfanspeed="90"
                        ;;
                6[6-9])
                        newfanspeed="100"
                        ;;
                7[0-5])
                        newfanspeed="100"
                        ;;
                7[6-9])
                        newfanspeed="100"
                        ;;
                *)
                        newfanspeed="100"
                        ;;
        esac
        
        nvidia-settings -a "[fan-${i}]/GPUTargetFanSpeed=${newfanspeed}" 2>&1 >/dev/null
        
        if [ "$verbose" = true ] ; then
            echo "gpu ${i} new fanspeed ${newfanspeed}"; 
        fi
        
        sleep 1s
    #increment gpu index
    i=$(($i+1))
    done
done

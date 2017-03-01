#!/usr/bin/env bash
 
logger Starting Xsession for Kiosk mode.
 
#Disable mouse right-click
xmodmap -e "pointer = 1 2 99"
 
matchbox-window-manager &
 
while true; do
 
        #Enable NumLock
        /usr/bin/numlockx on
 
        # Discard any Chromium preferences
        rm -rf ~/.config/chromium
        rm -rf ~/.cache
 
        /usr/bin/chromium-browser --noerrdialogs --incognito --kiosk http://localhost;
 
        logger Restarting Kiosk browser.
 
        sleep 1s;
done
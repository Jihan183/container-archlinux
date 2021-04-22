#!/bin/sh

# disable power manager display management
xfconf-query --channel xfce4-power-manager \
    --create --property /xfce4-power-manager/dpms-enabled --type 'bool' --set 'false'
# disable screensaver
xfconf-query --channel xfce4-screensaver \
    --create --property /xfce4-screensaver/lock/enabled --type 'bool' --set 'false'
xfconf-query --channel xfce4-screensaver \
    --create --property /xfce4-screensaver/saver/enabled --type 'bool' --set 'false'

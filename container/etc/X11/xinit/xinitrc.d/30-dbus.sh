#!/bin/bash

# https://wiki.archlinux.org/index.php/init#Dbus
# launches a session dbus instance
if [ -z "${DBUS_SESSION_BUS_ADDRESS-}" ] && type dbus-launch >/dev/null; then
    eval "$(dbus-launch --sh-syntax --exit-with-session)"
fi

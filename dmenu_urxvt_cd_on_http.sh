#!/bin/bash

DIR=$(ls /srv/http/projects/ | dmenu -i -fn "xft:Inconsolata:size=10" -p "Choose working dir")

urxvt -cd `echo "/srv/http/projects/${DIR}"`

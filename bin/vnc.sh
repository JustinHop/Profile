#!/bin/bash

x11vnc \
   -shared \
   -forever \
   -avahi \
   -rfbport 1930 \
   -passwdfile ~/vnc \
   -xkb

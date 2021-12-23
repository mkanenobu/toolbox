#!/usr/bin/env bash

ID=$(adb devices | awk -F'device' '{if (match($0, /device$/)) print $1}');
echo "$ID"
IP=$(adb shell ifconfig wlan0 | awk '{if (sub(/inet addr:/,"")) print $1 }');
echo "$IP"

adb tcpip 5555;
adb connect "$IP:5555"

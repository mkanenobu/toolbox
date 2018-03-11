#!/bin/sh
# If olasonic speaker exists, then set it to default audio device
if [ "$(pacmd list-sinks | grep -A 1 "\*\ index" | grep "name" | sed -e s/'\t'//g)" != "name: <alsa_output.pci-0000_00_1b.0.analog-stereo>" ]; then
    pacmd set-default-sink alsa_output.pci-0000_00_1b.0.analog-stereo
    echo "Switch to speaker"
elif [ -n "$(pacmd list-sinks | grep "usb-BurrBrown_from")" ]; then
    pacmd set-default-sink alsa_output.usb-BurrBrown_from_Texas_Instruments_USB_AUDIO_DAC-00.analog-stereo
    echo "Switch to USB speaker"
elif [ -n "$(pacmd list-sinks | grep "PanasonicTV1")" ]; then
    pacmd set-default-sink alsa_output.pci-0000_00_03.0.hdmi-stereo
    echo "Switch to TV"
else
    pacmd set-default-sink alsa_output.pci-0000_00_1b.0.analog-stereo
    echo "Switch to speaker"
fi

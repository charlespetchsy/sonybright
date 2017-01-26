#!/bin/bash

# Author: Charles Petchsy

# Most parts were cited from http://ubuntuforums.org/showthread.php?t=2088190
# A script specifically for Sony hardware (Sony Vaio T series)
# Can easily run this script via Terminal and provides all the files needed
# to fix the backlighting issue (requires root)

mkdir sony_scripts
cd sony_scripts

# This section provides a permission change for all files (executable)
cat <<EOF >> update # to run this just type "sh update" without quotes
sudo chmod +x /etc/acpi/events/sony-brightness-up
sudo chmod +x /etc/acpi/events/sony-brightness-down
sudo chmod +x /etc/acpi/brightdown.sh
sudo chmod +x /etc/acpi/brightup.sh

sudo service acpid restart
EOF

mkdir acpi
cd acpi

# Increment levels of backlighting
cat <<'EOF' >> brightup.sh
!/bin/bash
curr=`cat /sys/class/backlight/intel_backlight/actual_brightness`
if [ $curr -lt 4477 ]; then
   curr=$((curr+406));
   echo $curr  > /sys/class/backlight/intel_backlight/brightness;
fi
EOF

# Decrement levels of backlighting
cat <<'EOF' >> brightdown.sh
#!/bin/bash
curr=`cat /sys/class/backlight/intel_backlight/actual_brightness`
if [ $curr -gt 406 ]; then
   curr=$((curr-406));
   echo $curr  > /sys/class/backlight/intel_backlight/brightness;
fi
EOF

mkdir events
cd events

# "SNC 00000001 00000011" and "SNC 00000001 00000010" was the default output
# when acpi_listen is called in terminal along with actualization of fn keys
cat <<'EOF' >> sony-brightness-up
event=sony/hotkey SNC 00000001 00000011
action=/etc/acpi/brightup.sh
EOF

cat <<'EOF' >> sony-brightness-down
event=sony/hotkey SNC 00000001 00000010
action=/etc/acpi/brightdown.sh
EOF

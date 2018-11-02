#!/bin/bash

echo " -=- Removing software -=-"
sudo apt -y purge libav-tools screen lighttpd php php-cgi git

sudo rm /var/www/ipmipasswd
sudo rm /etc/lighttpd/lighttpd.conf

sudo rm -rf /var/www/html

sudo rm /etc/ipmi.conf


sudo rm /etc/rc.local 

echo " -=- Logging into the Pi0 -=-"
LOGINSUCCESS=0
while [ $LOGINSUCCESS -eq 0 ]; do
	if ! /opt/diy-ipmi/Pi3/checkPi0Login.sh; then
		echo " -=- Logging into the Pi0 as 'pi' with password 'raspberry' has failed -=-"
		echo "     Open another terminal session and use 'screen /dev/ttyUSB0 115200' to login to the Pi0"
		echo "     Once logged in, hit 'Ctrl-A' then type ':quit' to exit the screen session"
		echo "     Lastly, return here and press 'Enter' to continue or 'Ctrl-C' to give up. -=-"
		read CONT
	else
		LOGINSUCCESS=1
	fi
done

echo " -=- Setting up auto login on the serial terminal -=-"
echo "sudo systemctl disable serial-getty@ttyAMA0.service" >> /dev/ttyUSB0
echo "sudo rm /etc/systemd/system/serial-getty@ttyAMA0.service" >> /dev/ttyUSB0
echo "sudo systemctl daemon-reload" >> /dev/ttyUSB0

echo "sudo systemctl enable networking" >> /dev/ttyUSB0
echo "sudo apt-get -y install dhcpcd5 isc-dhcp-client isc-dhcp-common" >> /dev/ttyUSB0
echo " -=- Waiting for install of network to complete (90s) -=-"
sleep 90

echo " -=- Transfering files to Pi0 for HID -=-"
echo "rm -f /tmp/B64" >> /dev/ttyUSB0
echo "rm -f /home/pi/enableHID.sh" >> /dev/ttyUSB0

echo " -=- Transfering files to Pi0 for HID send keys -=-"
echo "rm -f /tmp/B64" >> /dev/ttyUSB0
echo "rm -f sendkeys.c" >> /dev/ttyUSB0

echo " -=- Compiling and transfering files to Pi0 for HID reset -=-"
echo "rm -f /home/pi/hub-ctrl" >> /dev/ttyUSB0
cd -

echo " -=- Enabling HID on Pi0 and adding boot options -=-"
echo "sudo rm -f /etc/rc.local" >> /dev/ttyUSB0
sudo rm -rf /opt/diy-ipmi
sudo rm -f /home/pi/install.sh
echo " -=- Uninstall Finished! -=-"

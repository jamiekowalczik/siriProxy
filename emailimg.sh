#!/bin/bash
wget "http://1.1.1.1/img/snapshot.cgi?size=3&quality=1" -O webcam.jpg >> /dev/null 2>&1
/usr/bin/email -t someemail@here.com -f someemail@here.com -a "webcam.jpg" -s "Basement Camera" -b "Basement Camera" >> /dev/null 2>&1
rm webcam.jpg >> /dev/null 2>&1
echo "Image Successfully Emailed"

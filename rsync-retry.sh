#!/bin/bash

### ABOUT
### Runs rsync, retrying on errors up to a maximum number of tries.
###
### from http://blog.iangreenleaf.com/2009/03/rsync-and-retrying-until-we-get-it.html
###
### dfbills 04.21.11
### note: may need to click server name in finder sidebar to get IPv6 address lookup
###
### changelog
#	10.09.13 changed timeout from 90 to 500
#
# Startup

clear

	# Write log
	echo "$(date) - Starting iTunes Backup"  >> /Users/dfbills/Applications/itunes_backup.log
	
	# Notify
	echo "$(date) - Starting iTunes Backup..."
	
	# Notify via Growl
	growlnotify -m "Starting up..." "iTunes Backup"

# Trap interrupts and exit instead of continuing the loop
trap "echo Exited!; exit;" SIGINT SIGTERM

MAX_RETRIES=50
i=0

# Set the initial return value to failure
false

while [ $? -ne 0 -a $i -lt $MAX_RETRIES ]
do
 i=$(($i+1))
if [ $i -eq 1 ]
then
	rsync -avz --stats --progress --partial --delete --timeout=500 --exclude-from=/Users/dfbills/.rsync/exclude mini.members.btmm.icloud.com:/Volumes/Drobo/MP3/Archive/ /Volumes/Drobo\ HD/Music\ Archive/
else
	# Write log
	echo "$(date) - Retry #$i."  >> /Users/dfbills/Applications/itunes_backup.log
	
	# Notify
	echo "$(date) - Retry #$i."
	
	# Notify retry via Growl
	growlnotify -m "Retry #$i." "iTunes Backup"
 rsync -avz --stats --progress --partial --delete --timeout=500 --exclude-from=/Users/dfbills/.rsync/exclude mini.members.btmm.icloud.com:/Volumes/Drobo/MP3/Archive/ /Volumes/Drobo\ HD/Music\ Archive/
fi
done

if [ $i -eq $MAX_RETRIES ]
then

	# Write log
	echo "$(date) - Hit maximum number of retries, giving up."  >> /Users/dfbills/Applications/itunes_backup.log

	# Notify
	echo "$(date) - Hit maximum number of retries, giving up."

  	# Notify failure via Growl
	growlnotify -m "Hit maximum number of retries, giving up." "iTunes Backup"

fi
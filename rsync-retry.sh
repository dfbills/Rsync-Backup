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
#	09.18.14 Notifications are now displayed in OSX Notification via terminal-notifier, rather than Growl.
#		https://github.com/alloy/terminal-notifier
#

# Startup

clear

	# Write log
	echo "$(date) - Starting iTunes Backup"  >> /Users/username/Applications/itunes_backup.log
	
	# Notify
	echo "$(date) - Starting iTunes Backup..."
	
	# Notify via OSX Notifications
	terminal-notifier -title 'Rsync Music Backup' -message 'Starting up...'

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
	rsync -avz --stats --progress --partial --delete --timeout=500 --exclude-from=/Users/username/.rsync/exclude machine_name.members.btmm.icloud.com:/Volumes/Drobo/MP3/Archive/ /Volumes/Drobo\ HD/Music\ Archive/
else
	# Write log
	echo "$(date) - Retry #$i."  >> /Users/username/Applications/itunes_backup.log
	
	# Notify
	echo "$(date) - Retry #$i."
	
	# Notify retry via OSX Notifications
	terminal-notifier -title 'Rsync Music Backup' -message 'Retry #$i.'
 rsync -avz --stats --progress --partial --delete --timeout=500 --exclude-from=/Users/username/.rsync/exclude machine_name.members.btmm.icloud.com:/Volumes/Drobo/MP3/Archive/ /Volumes/Drobo\ HD/Music\ Archive/
fi
done

if [ $i -eq $MAX_RETRIES ]
then

	# Write log
	echo "$(date) - Hit maximum number of retries, giving up."  >> /Users/username/Applications/itunes_backup.log

	# Notify
	echo "$(date) - Hit maximum number of retries, giving up."

  	# Notify failure via OSX Notifications
	terminal-notifier -title 'Rsync Music Backup' -message 'Hit maximum number of retries, giving up.'

fi
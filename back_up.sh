#!/bin/bash
#crontab -e
#1 0 * * * /home/bchainadmin/back_up.sh
LOG_DT=$(date +"%Y/%m/%d %H:%M:%S.%3N")
FILE_FORMAT=$(date +"%Y%m%d%H%M%S")
FILE_RESULT="/home/bchainadmin/backup/backup_$FILE_FORMAT.log"

backup_file()
{
	DEST=$1
	SOURCE=$2
	#create the backup
	echo "create the backup"
	tar -cpzf $DEST $SOURCE
	echo "delete SOURCE FILE"
	rm -r $SOURCE
	echo "new file"
	touch $SOURCE
}

echo "$LOG_DT|### Start backup node1" | tee -a $FILE_RESULT
BACKUPTIME=$(date +%Y%m%d-%H%M%S)
#create a backup file using the current date in it's name
DESTINATION=/home/bchainadmin/backup/node1-$BACKUPTIME.tar.gz 
#the folder that contains the files that we want to backup
SOURCEFOLDER=/home/bchainadmin/eth-dwallet/node1/screenlog.0
backup_file $DESTINATION $SOURCEFOLDER
echo "$LOG_DT|### End backup node1" | tee -a $FILE_RESULT

echo "$LOG_DT|### Start backup nodejs" | tee -a $FILE_RESULT
BACKUPTIME=$(date +%Y%m%d-%H%M%S)
#create a backup file using the current date in it's name
DESTINATION=/home/bchainadmin/backup/nodejs-$BACKUPTIME.tar.gz 
#the folder that contains the files that we want to backup
SOURCEFOLDER=/home/bchainadmin/eth-dwallet/projectDwallet/screenlog.0
backup_file $DESTINATION $SOURCEFOLDER
echo "$LOG_DT|### End backup nodejs" | tee -a $FILE_RESULT

echo "$LOG_DT|### Start backup explorer" | tee -a $FILE_RESULT
BACKUPTIME=$(date +%Y%m%d-%H%M%S)
#create a backup file using the current date in it's name
DESTINATION=/home/bchainadmin/backup/explorer-$BACKUPTIME.tar.gz 
#the folder that contains the files that we want to backup
SOURCEFOLDER=/home/bchainadmin/explorer/screenlog.0
backup_file $DESTINATION $SOURCEFOLDER
echo "$LOG_DT|### End backup explorer"  | tee -a $FILE_RESULT

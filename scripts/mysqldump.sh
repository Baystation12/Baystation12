#!/bin/bash
### Hugo's basic MySQL backup script ###

#Username to log into your MySQL server
USER="user"

#Password for that user above
PASS="password"

#The ip address of your MySQL server, localhost if it's on this server
HOST="localhost"

#Defines DATE as today's date (don't touch this)
DATE=$(/bin/date +%Y-%m-%d)

#The location you want your backups, file is called MySQLdump-(today's date)
BAK="/home/ss13/mysql-backups/MySQLdump-$DATE"

#The name of the schema (database)
SCHEMA="tgstation"

#You don't need to change this \/

#The dump command, -h sets host, -u sets user, -p sets password, $SCHEMA is defined above, --result-file is the name of the dump file and where it is saved.
mysqldump -h$HOST -u $USER -p$PASS $SCHEMA --result-file $BAK

#Checks if the file was created, hopefully whether or not the backup worked.
if [ -f $BAK ];
	then	echo "Backup completed"
	else	echo "Backup failed"
fi

#Common issues

#mysqldump: Can't create/write to file '' (Errcode: 2)
#The directory you're trying to save to doesn't exist, create it first. I have also encountered this issue while trying to use ~ to reference home, try putting the full path instead.

#-bash: ./mysqldump.sh: Permission denied
#You do not have execution permission on the shell script, use "chmod +x mysqldump.sh" to claim execution ownership of the file. See Linux permissions for more info.



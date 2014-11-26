#!/bin/bash

# Config
dbhost="localhost"
dbuser="******"
dbpass="******"
prefix="modx_"

site="******"
db="******"

# Init
rnd=$RANDOM
time=$(date +%H-%M-%S)
date=$(date +%Y-%m-%d)

truncate="\"TRUNCATE "$prefix"session\""

pathFrom="../public_html"
pathTo="../backups"
folder="$site-$date=$time.bck"

echo -ne "Truncate sessions... "
#mysql -h $dbhost -u $dbuser -p$dbpass -e $truncate $def_db
rc=$?
if [[ $rc != 0 ]]; then
 echo -e "\e[31merror\e[39m"
 exit $rc
else
 echo -e "\e[32mOK\e[39m"
fi

echo -ne "Clean cache......... "
#rm -rf $pathFrom/core/cache	#clean cache
rc=$?
if [[ $rc != 0 ]]; then
 echo -e "\e[31merror\e[39m"
 exit $rc
else
 echo -e "\e[32mOK\e[39m"
fi

echo -ne "New folder.......... "
mkdir -p $pathTo/$folder
rc=$?
if [[ $rc != 0 ]]; then
 echo -e "\e[31merror\e[39m"
 exit $rc
else
 echo -e "\e[32mOK\e[39m"
fi

echo -ne "Dumping database.... "
# mysqldump -h $dbhost -u $dbuser -p$dbpass $db > $pathTo/$folder/dump-$db-$date=$time.sql	#dump database
rc=$?
if [[ $rc != 0 ]]; then
 echo -e "\e[31merror\e[39m"
 exit $rc
else
 echo -e "\e[32mOK\e[39m"
fi

echo "Archive data...     "
# zip -r $pathTo/$folder/archive_$date=$time.zip docs	# archive files
#tar --exclude-from=exclude.list -czv -f $pathTo/$folder/archive_$date=$time.tar $pathFrom
rc=$?
if [[ $rc != 0 ]]; then
 echo -e "\e[31merror\e[39m"
 exit $rc
else
 echo -e "\e[32mOK\e[39m"
fi
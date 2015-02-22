#!/bin/bash

# Config
dbhost="localhost"
dbuser="your_dbuser"
dbpass="your_dbpass"
dbname="your_dbname"
prefix="modx_"

site="domain.ru"
pathFrom=$site
pathTo="../backups/"$site

# Init
rnd=$RANDOM
time=$(date +%H-%M-%S)
date=$(date +%Y-%m-%d)

truncate="\"TRUNCATE "$prefix"session\""
folder="$site-$date=$time.bck"


echo -ne "Truncate sessions... "
false
#echo -h $dbhost -u $dbuser -p$dbpass -e $truncate $dbname
#mysql -h $dbhost -u $dbuser -p$dbpass -e $truncate $dbname
rc=$?
if [[ $rc != 0 ]]; then
 echo -e "\e[31merror\e[39m"
#exit $rc
else
 echo -e "\e[32mOK\e[39m"
fi


#echo -ne "Clean cache......... "
#rm -rf $pathFrom/core/cache	#clean cache
#rc=$?
#if [[ $rc != 0 ]]; then
# echo -e "\e[31merror\e[39m"
## exit $rc
#else
# echo -e "\e[32mOK\e[39m"
#fi

echo -ne "New folder.......... "
false
mkdir -p $pathTo/$folder
rc=$?
if [[ $rc != 0 ]]; then
 echo -e "\e[31merror\e[39m"
 exit $rc
else
 echo -e "\e[32mOK\e[39m"
fi

echo -ne "Dumping database.... "
false
mysqldump -h $dbhost -u $dbuser -p$dbpass $dbname > $pathTo/$folder/dump-$dbname-$date=$time.sql	#dump database
rc=$?
if [[ $rc != 0 ]]; then
 echo -e "\e[31merror\e[39m"
 exit $rc
else
 echo -e "\e[32mOK\e[39m"
fi

echo -ne "Archive data........ "
false
# zip -r $pathTo/$folder/archive_$date=$time.zip docs	# archive files
tar --exclude=core/cache -cz -f $pathTo/$folder/archive_$date=$time.tar $pathFrom
rc=$?
if [[ $rc != 0 ]]; then
 echo -e "\e[31merror\e[39m"
 exit $rc
else
 echo -e "\e[32mOK\e[39m"
fi
echo -e "\e[32mSave done.\e[39m"

#!/bin/bash

# Config
dbhost="localhost"
dbuser="dbuser"
dbpass="dbpass"

dbname="dbname"
prefix="modx_"

site="domain.ru"
pathFrom="relatine/or/absolute_path"$site
pathTo="/var/www/absolute_path/data/Dropbox/backups/"$site

# ѕарсинг параметров
mode=console
while getopts "m:" opt; do
    case "$opt" in
    m)  mode=$OPTARG
        ;;
    esac 
done

# ÷ветные в консоль, одноцветные в лог
if [[ $mode == console ]]; then
 #echo "console"
 OK="\e[32mOK\e[39m"
 ERROR="\e[31mERROR\e[39m"
else
 #echo "b/w"
 OK="OK; "
 ERROR="ERROR; "
fi

# Dir fixes
baseDir=$(pwd)
cd $pathFrom
pathFrom=$(pwd)
cd $baseDir

# Init
rnd=$RANDOM
time=$(date +%H-%M-%S)
date=$(date +%Y-%m-%d)

truncate="\"TRUNCATE "$prefix"session\""
folder="$site-$date=$time.bck"

echo -ne "Truncate sessions... "
false
#echo mysql -h $dbhost -u $dbuser -p$dbpass -e $truncate $dbname
#/usr/bin/mysql -h $dbhost -u $dbuser -p$dbpass -e $truncate $dbname
rc=$?
if [[ $rc != 0 ]]; then
 echo -e $ERROR
else
 echo -e $OK
fi

#echo -ne "Clean cache......... "
#rm -rf $pathFrom/core/cache	#clean cache
#rc=$?
#if [[ $rc != 0 ]]; then
# echo -e $ERROR
#else
# echo -e $OK
#fi

echo -ne "New folder.......... "
false
mkdir -p $pathTo/$folder
rc=$?
if [[ $rc != 0 ]]; then
 echo -e $ERROR
 exit $rc
else
 echo -e $OK
fi

echo -ne "Dumping database.... "
false
mysqldump -h $dbhost -u $dbuser -p$dbpass $dbname > $pathTo/$folder/dump-$dbname-$date=$time.sql	#dump database
rc=$?
if [[ $rc != 0 ]]; then
 echo -e $ERROR
 exit $rc
else
 echo -e $OK
fi

echo -ne "Archive data........ "
false
# zip -r $pathTo/$folder/archive_$date=$time.zip docs	# archive files
tar --exclude=core/cache -cz -f $pathTo/$folder/archive_$date=$time.tar $pathFrom
rc=$?
if [[ $rc != 0 ]]; then
 echo -e $ERROR
 exit $rc
else
 echo -e $OK
fi

echo -e $site"\e[32m Successfully saved\e[39m"
exit 0
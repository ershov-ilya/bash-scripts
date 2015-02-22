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

folder="$site-$date=$time.bck"

ls $pathFrom/$1
rc=$?
if [[ $rc != 0 ]]; then
 echo -e "\e[31merror\e[39m"
 exit $rc
else
 echo -e "\e[32mOK\e[39m"
fi

archive_name=$(ls $pathFrom/$1 | grep .tar)

echo -ne "Delete old files...   "
false
rm -r $pathTo
rc=$?
if [[ $rc != 0 ]]; then
 echo -e "\e[31merror\e[39m"
# exit $rc
else
 echo -e "\e[32mOK\e[39m"
fi

echo -ne "Unpack archive...     "
false
tar -xz -f $pathFrom/$1/$archive_name
#echo $pathFrom/$1/$archive_name
rc=$?
if [[ $rc != 0 ]]; then
 echo -e "\e[31merror\e[39m"
 exit $rc
else
 echo -e "\e[32mOK\e[39m"
fi

#echo -ne "Copy backup files... "
#false
#cp  $pathFrom/$1/$site pathTo
#rc=$?
#if [[ $rc != 0 ]]; then
# echo -e "\e[31merror\e[39m"
# exit $rc
#else
# echo -e "\e[32mOK\e[39m"
#fi

dump_name=$(ls $pathFrom/$1 | grep .sql)

echo -ne "Restore mysql dump... "
false
mysql -u $dbuser -p$dbpass $dbname < $pathFrom/$1/$dump_name
rc=$?
if [[ $rc != 0 ]]; then
 echo -e "\e[31merror\e[39m"
 exit $rc
else
 echo -e "\e[32mOK\e[39m"
fi

echo -e "\e[32mRestore done.\e[39m"

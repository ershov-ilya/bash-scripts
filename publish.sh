#!/bin/bash

# Config
dbhost="******"
dbuser="******"
dbpass="******"

donor_site="******"
donor_db="******"

target_site="******"
target_db="******"

tmp="tmp"

# Set vars
DIR="$( cd "$( dirname "$0" )" && pwd )"
echo $DIR
BASE="$( cd .. && pwd )"
echo $BASE


# Clean temp folder
echo -ne "Cache clean... "
rm -r $tmp
mkdir $tmp
rc=$?
if [[ $rc != 0 ]]; then
 echo "error"
 exit $rc
else
 echo "OK"
fi

echo -ne "Dumping...     "
mysqldump -h$dbhost -u$dbuser -p$dbpass $donor_db > $DIR/$tmp/dump.sql
rc=$?
if [[ $rc != 0 ]]; then
 echo "error"
 exit $rc
else
 echo "OK"
fi

echo -ne "Dump upload... "
mysql -h$dbhost -u$dbuser -p$dbpass $target_db < $DIR/$tmp/dump.sql
rc=$?
if [[ $rc != 0 ]]; then
 echo "error"
 exit $rc
else
 echo "OK"
fi


echo -ne "MODX cache clean... "
rm -rf $BASE/$donor_site/docs/core/cache	#clean cache
rc=$?
if [[ $rc == 0 ]]; then
 echo "OK"
else
 echo "error"
 exit $rc
fi

echo -ne "Sync files...  "
rsync -r --inplace --partial --delete-after --exclude=*access --exclude=robots.txt --exclude=config.inc.php --exclude=config.core.php --no-compress $BASE/$donor_site/docs/ $BASE/$target_site/docs
rc=$?
if [[ $rc == 0 ]]; then
 echo "OK"
else
 echo "error"
echo "Manual sync files...  "
echo "rsync -r --inplace --partial --delete-after --exclude=*access --exclude=robots.txt --exclude=config.inc.php --exclude=config.core.php --no-compress"
echo "from $BASE/$donor_site/docs/"
echo "to $BASE/$target_site/docs"
 exit $rc
fi


# Return code
exit 0

# After each command, the exit code can be found in the $? variable so you would have something like:
#ls -al file.ext
#rc=$?
#if [[ $rc != 0 ]] ; then
#    exit $rc
#fi
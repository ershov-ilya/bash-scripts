basePath="/var/www/absolute_path/scripts/"
log=$basePath"cron/log.txt"
date >> $log

cd $basePath"backup"

site="domain.ru"
./save-domain.ru.sh

rc=$?
if [[ $rc != 0 ]]; then
 echo $site" save ERROR, code:"$rc"; " >> $log
else
 echo $site" saved OK; " >> $log
fi

site="domain2.com"
./save-domain2.com.sh

rc=$?
if [[ $rc != 0 ]]; then
 echo $site" save ERROR, code:"$rc"; " >> $log
else
 echo $site" saved OK; " >> $log
fi

echo "" >> $log
echo "Done."
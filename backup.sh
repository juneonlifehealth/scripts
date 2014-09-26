!/bin/bash
# v.1.0 09/03/2014
# Created by Lijun Gu
# this script backup the data and database ddl  as dump file

backup_dir=/data/pgsql/backup/
myhost=`hostname`
start_date=`date +%m%d%y"_"%H%M`
dbname=$1
#dbname=eligibility_service_int
#maillist="lijun_gu@onlifehealth.com"
maillist="lijun_gu@onlifehealth.com, aubrey_nicholson@onlifehealth.com, charles_johnston@onlifehealth.com"
#maillist="SQLDBA@onlifehealth.com"
errorlog="${backup_dir}/${dbname}${start_date}.log"

 if [ -s $dbname ] ; then
                echo "Usage: ./backup.sh database_name "
                exit 1
 fi

echo -e  `date` > $errorlog
echo -e  " \n Start backup for database ${dbname} on ${myhost}  \n"  >> $errorlog
cd /usr/pgsql-9.3/bin
pg_dump -p 9001 -Fp -C ${dbname} > ${backup_dir}/${dbname}${start_date} 2>> $errorlog


if [[ $? -ne 0 ]]
then
   echo " An error has occurred, backup failed" >> $errorlog
   mail -s "ALERT: $myhost  Backup issue" ${maillist} < ${errorlog}  2> /dev/null
   exit
else
   echo -e "Fiinished backup at `date` " >> $errorlog
   echo " backup $1 successful" >> $errorlog
   mail -s "$myhost Backup Report" ${maillist} < ${errorlog}  2> /dev/null
   exit 1

fi


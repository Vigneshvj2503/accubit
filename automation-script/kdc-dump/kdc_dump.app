mkdir -p /nyl/kdcdumpbkp/
chmod 755 /nyl/kdcdumpbkp/
NODE=`hostname | cut -d '.' -f1 | tail -c 2`
CURRENT_ENV=`hostname | cut -d'.' -f2`
FROM_ADDRESS=no-reply.kdc${NODE}.${CURRENT_ENV}@newyorklife.com
TO_ADDRESS=EIS_DevOps_Team@newyorklife.com
DISKSPACEROOT=`df /dev/xvda1 | awk '{print $5}' | sed 's/[Use%]//g'`
DISKSPACEEBS=`df /dev/xvdf | awk '{print $5}' | sed 's/[Use%]//g'`
DISKSPACEROOT_SIZE=95
DISKSPACEEBS_SIZE=95
CURRENT_DATE=`date '+%Y-%m-%d-%H-%M-%S'`
DUMP_PATH=/var/tmp/
BKP_DUMP_PATH=/nyl/kdcdumpbkp/
SLAVE_SERVER=kdc2.${CURRENT_ENV}.eis.nylcloud.com
SLAVE_SERVER2=kdc3.${CURRENT_ENV}.eis.nylcloud.com
DUMP_FILE=`which /usr/sbin/kdb5_util`
DUMP_SLAVE=`which /usr/sbin/kprop`
LOGROTATE_RETENTION='+7'
MAIL_SEND_FLAG="true"


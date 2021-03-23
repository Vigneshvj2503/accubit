#!/bin/bash
mkdir -p /var/log/eis/
chmod -R 775 /var/log/eis/
exec > >(tee /var/log/eis/kafka-mm-cron.log|logger -t kafka-mm-cron -s 2>/dev/console) 2>&1
echo "`date '+%Y-%m-%d %H:%M:%S'`: kafka-mm Autorecovery Monitor started....."
/sbin/service kafka-mm status > /dev/null
if [ $? != 0 ]
then
        /sbin/service kafka-mm auto > /dev/null

        echo "`date '+%Y-%m-%d %H:%M:%S'`: kafka-mm Autorecovery Monitor found something isnt okay, so triggered started @@....."
fi

echo "`date '+%Y-%m-%d %H:%M:%S'`: kafka-mm Autorecovery Monitor Closing....."


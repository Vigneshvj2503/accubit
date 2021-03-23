#!/bin/bash
#################################
# Created by : EIS Devops
# Date : 2019-06-04
# Type: Foundation Recovery 
#################################

## Log Pre-Reqs ####
mkdir -p /var/log/eis/
chmod -R 775 /var/log/eis/

## Starting Logger ####
exec > >(tee /var/log/eis/turbine-cron.log|logger -t turbine-cron -s 2>/dev/console) 2>&1
echo "`date '+%Y-%m-%d %H:%M:%S'`: Turbine Autorecovery Monitor started....."
/sbin/service turbine status > /dev/null
if [ $? != 0 ]
then
        sudo service turbine start > /dev/null
	echo "`date '+%Y-%m-%d %H:%M:%S'`: Turbine Autorecovery Monitor found something isnt okay, so triggered started @@....."
fi
echo "`date '+%Y-%m-%d %H:%M:%S'`: Turbine Autorecovery Monitor Closing....."



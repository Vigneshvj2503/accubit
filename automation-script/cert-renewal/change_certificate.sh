#!/bin/sh
mkdir -p /home/ec2-user/oldcert
mkdir -p /home/ec2-user/newcert
JKS_PATH=/nyl/eis/ms/app/
APP_ENV="$1"
MY_PATH=${JKS_PATH}${APP_ENV}.eis.nylcloud.com.jks
sudo /etc/init.d/supervisord stop
 cp ${MY_PATH} /home/ec2-user/oldcert
curl -o  /home/ec2-user/newcert/${APP_ENV}.eis.nylcloud.com.jks "http://artifactory.eis.nonprod.nylcloudlabs.com/artifactory/automation/jks/${APP_ENV}.eis.nylcloud.com.jks"
cp /home/ec2-user/newcert/${APP_ENV}.eis.nylcloud.com.jks ${JKS_PATH}
chmod 644 ${MY_PATH}
sleep 10s
sudo /etc/init.d/supervisord start

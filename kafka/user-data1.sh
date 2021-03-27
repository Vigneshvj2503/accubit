#!/bin/bash
exec > >(tee /home/ec2-user/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1
echo BEGIN
yum update -y
cd /home/ec2-user/
sudo yum install git -y
su - ec2-user -c cat <<'EOF' >> /home/ec2-user/.ssh/config
Host *
StrictHostKeyChecking no
UserKnownHostsFile=/dev/null
EOF
su - ec2-user -c 'chmod 0600 /home/ec2-user/.ssh/config'
su - ec2-user -c 'chmod 0600 /home/ec2-user/.ssh/id_rsa'
su - ec2-user -c 'chmod 0600 /home/ec2-user/.ssh/id_rsa.pub'
cd /home/ec2-user
su - ec2-user -c 'git clone -b hdf-awsos-migration https://eis-user:7231af110bf5ed0b35e01fd5f933118b74904426@git.nylcloud.com/EIS/microservices-config.git'
cd microservices-config/hdf/common
sh /home/ec2-user/microservices-config/hdf/common/ambari-agent-setup.sh  prod 1 kafkahdf
#sh /home/ec2-user/microservices-config/hdf/common/ambari-server-setup.sh dev
sleep 30
mkfs -t ext4 /dev/xvdf
mkdir /nyl
mount /dev/xvdf /nyl
echo "/dev/xvdf       /nyl   auto    defaults     0       0"  >> /etc/fstab
sleep 30
######JKS Steps###################################33333
sudo mkdir /etc/security/jks
sudo cp /home/ec2-user/microservices-config/jks/prod.eis.nylcloud.com.jks /etc/security/jks/
sudo yum install -y http://artifactory.eis.nonprod.nylcloudlabs.com/artifactory/list/automation/puppet/agent/puppet-agent-5.5.20-1.el6.x86_64.rpm
/opt/puppetlabs/bin/puppet  apply -e "exec { 'git-wp': command => '/usr/bin/git clone https://eis-user:7231af110bf5ed0b35e01fd5f933118b74904426@git.nylcloud.com/EIS/biolerplate.git /opt/biolerplate' }"
/opt/puppetlabs/bin/puppet apply /opt/biolerplate/manifests/java.pp --modulepath=/opt/biolerplate/modules/ --hiera_config=/opt/biolerplate/hiera.yaml
sudo /bin/keytool -keystore /etc/security/jks/server.truststore.jks -storepass changeit -noprompt -alias CARoot -import -file /home/ec2-user/microservices-config/consul/CA/CORP-PKIR01.cer
sudo /bin/keytool -keystore /etc/security/jks/server.truststore.jks -storepass changeit -noprompt -alias CAIntermediate -import -file /home/ec2-user/microservices-config/consul/CA/CORP-PKIS01-CA.cer
sudo /bin/keytool  -import -alias service-cert-root -keystore /etc/pki/ca-trust/extracted/java/cacerts -storepass changeit -noprompt -file  /home/ec2-user/microservices-config/consul/CA/CORP-PKIR01.cer
sudo /bin/keytool  -import -alias service-cert-intermediate -keystore /etc/pki/ca-trust/extracted/java/cacerts -storepass changeit -noprompt -file  /home/ec2-user/microservices-config/consul/CA/CORP-PKIS01-CA.cer
chmod 644 /etc/security/jks/prod.eis.nylcloud.com.jks
chmod 644 /etc/security/jks/server.truststore.jks

#########krb5.config###########
sudo sh /home/ec2-user/microservices-config/common/template_to_original.sh /home/ec2-user/microservices-config/common/env_prod.properties /home/ec2-user/microservices-config/common/krb5.conf.template > /etc/krb5.conf
sudo yum install krb5-workstation -y


###############sumo########
sudo wget http://artifactory.eis.nonprod.nylcloudlabs.com/artifactory/eis-software/hdf/sumologic_json/prod/prod_eis_ambari-agent_hdf.json &&  sudo wget http://artifactory.eis.nonprod.nylcloudlabs.com/artifactory/eis-software/hdf/sumologic_json/prod/prod_eis_ambari-metrics-monitor_hdf.json && sudo wget http://artifactory.eis.nonprod.nylcloudlabs.com/artifactory/eis-software/hdf/sumologic_json/prod/prod_eis-kafka_hdf.json


echo END
sleep 30
reboot



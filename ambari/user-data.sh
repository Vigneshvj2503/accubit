#!/bin/bash
exec > >(tee /home/ec2-user/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1
sudo yum install -y http://artifactory.eis.nonprod.nylcloudlabs.com/artifactory/list/automation/puppet/agent/puppet-agent-5.5.20-1.el6.x86_64.rpm
/opt/puppetlabs/bin/puppet apply -e "exec { 'ssh-config': provider => shell,  command => '/bin/echo -e \"Host *\n StrictHostKeyChecking no\n IdentityFile /home/ec2-user/.ssh/id_rsa\n UserKnownHostsFile=/dev/null\" > /root/.ssh/config', }"
/opt/puppetlabs/bin/puppet  apply -e "package { 'git': ensure => 'installed', }"
/opt/puppetlabs/bin/puppet  apply -e "exec { 'git-wp': command => '/usr/bin/git clone https://eis-user:7231af110bf5ed0b35e01fd5f933118b74904426@git.nylcloud.com/EIS/biolerplate.git /opt/biolerplate' }"
/opt/puppetlabs/bin/puppet  apply -e "exec { 'git-wp': command => '/usr/bin/git clone -b hdf-awsos-migration  https://eis-user:7231af110bf5ed0b35e01fd5f933118b74904426@git.nylcloud.com/EIS/microservices-config.git /home/ec2-user/microservices-config' }"
sudo yum update -y
cd /home/ec2-user/
sudo yum install git -y
sudo su - ec2-user -c cat <<'EOF' >> /home/ec2-user/.ssh/config
Host *
StrictHostKeyChecking no
UserKnownHostsFile=/dev/null
EOF
sudo su - ec2-user -c 'chmod 0600 /home/ec2-user/.ssh/config'
sudo su - ec2-user -c 'chmod 0600 /home/ec2-user/.ssh/id_rsa'
sudo su - ec2-user -c 'chmod 0600 /home/ec2-user/.ssh/id_rsa.pub'

cd microservices-config/hdf/common
sudo sh /home/ec2-user/microservices-config/hdf/common/ambari-agent-setup.sh  prod 1 ashdf
sudo sh /home/ec2-user/microservices-config/hdf/common/ambari-server-setup.sh prod
#######https steps########
sudo mkdir /etc/security/certs
sudo cp /home/ec2-user/microservices-config/jks/certs/prod/cert.pem  /etc/security/certs/
sudo cp /home/ec2-user/microservices-config/jks/certs/prod/private.key  /etc/security/certs/
ambari-server setup-security --security-option=setup-https --api-ssl=true --api-ssl-port=8443 --import-cert-path=/etc/security/certs/cert.pem  --import-key-path=/etc/security/certs/private.key --pem-password=1qaz2wsx@
sudo service ambari-server restart
############krb5############
sudo sh /home/ec2-user/microservices-config/common/template_to_original.sh /home/ec2-user/microservices-config/common/env_prod.properties /home/ec2-user/microservices-config/common/krb5.conf.template > /etc/krb5.conf
sudo yum install krb5-workstation -y
#######Sumojson Files#############
cd /opt/sumoconfig/
sudo wget http://artifactory.eis.nonprod.nylcloudlabs.com/artifactory/eis-software/hdf/sumologic_json/prod/prod_eis_ambari-agent_hdf.json &&  sudo wget http://artifactory.eis.nonprod.nylcloudlabs.com/artifactory/eis-software/hdf/sumologic_json/prod/prod_eis-ambari-infra-solr-client_hdf.json && sudo wget http://artifactory.eis.nonprod.nylcloudlabs.com/artifactory/eis-software/hdf/sumologic_json/prod/prod_eis_ambari-infra-solr_hdf.json && sudo wget http://artifactory.eis.nonprod.nylcloudlabs.com/artifactory/eis-software/hdf/sumologic_json/prod/prod_eis_ambari-metrics-collector_hdf.json && sudo wget http://artifactory.eis.nonprod.nylcloudlabs.com/artifactory/eis-software/hdf/sumologic_json/prod/prod_eis_ambari-metrics-grafana_hdf.json && sudo wget http://artifactory.eis.nonprod.nylcloudlabs.com/artifactory/eis-software/hdf/sumologic_json/prod/prod_eis_ambari-metrics-monitor_hdf.json && sudo wget http://artifactory.eis.nonprod.nylcloudlabs.com/artifactory/eis-software/hdf/sumologic_json/prod/prod_eis_ambari-server_hdf.json
#######################
sleep 60
mkfs -t ext4 /dev/xvdf
cd /home/ec2-user/
sudo mkdir -p /nyl/
mount /dev/xvdf /nyl
echo "/dev/xvdf       /nyl   auto    defaults     0       0"  >> /etc/fstab
sleep 60
echo END
reboot

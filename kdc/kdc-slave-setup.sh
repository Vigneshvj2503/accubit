#!/bin/bash 
#Title       : kdc-slave-setup.sh
#Description : This script install and brings up the KDC Slave
#Author		 : Sivakumar Annamalai, Anand Sreenivasan
#Date        : 2017/10/01
#Usage		 : sh kdc-slave-setup.sh env kdc_host_no kdc_password_file_path

if [ "$#" -ne 3 ]; then
  echo "Please provide right number of arguments"
  echo "Usage: sh kdc-slave-setup.sh env kdc_host_no kdc_password_file_path"
  echo "Example: sh /home/ec2-user/microservices-config/common/kdc-slave-setup.sh devint 2 /tmp/password.txt" 
  exit 1
fi

## install required packages
source /home/ec2-user/microservices-config/common/common.properties
current_env=$1
env_prop_file=$common_dir/env_${current_env}.properties
echo "ID=$2" >> $env_prop_file
source $env_prop_file
chmod 777 -R $repo_dir
kdc_password=`cat $3`

## Java and krb5 installation
$common_dir/install_java.sh
$common_dir/install_krb5.sh
$common_dir/install_krb5_server.sh

## Generate the required Kerberos config files from the template and copy it to right location
sh $common_dir/template_to_original.sh $env_prop_file $kdc_dir/krb5.conf.template > /etc/krb5.conf 
sh $common_dir/template_to_original.sh $env_prop_file $kdc_dir/kadm5.acl.template > /var/kerberos/krb5kdc/kadm5.acl 
sh $common_dir/template_to_original.sh $env_prop_file $kdc_dir/kdc.conf.template > /var/kerberos/krb5kdc/kdc.conf 
sh $common_dir/template_to_original.sh $env_prop_file $kdc_dir/kdc-network.template > /etc/sysconfig/network 

## Initialize the database for the Realm
kdb5_util -r $REALM create -s -P $kdc_password

## All the below steps are required for slave to be in sync with master
mkdir -p /nyl/scripts/
sh $common_dir/template_to_original.sh $env_prop_file $kdc_dir/kpropd.acl.template >/var/kerberos/krb5kdc/kpropd.acl 
sh $common_dir/template_to_original.sh $env_prop_file $kdc_dir/kdc_dump.sh.template >/nyl/scripts/kdc_dump.sh 

## Manual steps to be done
## Rename keytab. Copy kdc2.keytab or kdc3.keytab from kdc1 host. Below keytab and the dump has to be copied from KDC master
## mv $KEYTABS_DIR/kdc2.keytab /etc/krb5.keytab

## start services and set loglevel
service kprop start
service krb5kdc start
chkconfig --level 2345 kprop on
chkconfig --level 2345 krb5kdc on

#!/bin/bash
#Title       : kdc-master-setup.sh
#Description : This script install and brings up the KDC Master
#Author		 : Sivakumar Annamalai, Anand Sreenivasan
#Date        : 2017/10/01
#usage		 : sh kdc-master-setup.sh env kdc_password_file_path oneway_trust_password_file_path

if [ "$#" -ne 3 ]; then
  echo "Please provide right number of arguments"
  echo "Usage: sh kdc-master-setup.sh env kdc_password_file_path"
  echo "Example: sh /home/ec2-user/microservices-config/kdc/kdc-master-setup.sh devint /tmp/password.txt /tmp/oneway_trust_password.txt" 
  exit 1
fi

source /home/ec2-user/microservices-config/common/common.properties
current_env=$1
env_prop_file=$common_dir/env_${current_env}.properties
source $env_prop_file
chmod 777 -R $repo_dir

## Copy the templates and property files to home directory
kdc_password=`cat $2`
oneway_trust_password=`cat $3`

## Java and krb5 installation
$common_dir/install_java.sh
$common_dir/install_krb5.sh
$common_dir/install_krb5_server.sh

## Generate the required Kerberos config files from the template and copy it to right location
sh $common_dir/template_to_original.sh $env_prop_file $kdc_dir/krb5.conf.template > /etc/krb5.conf
sh $common_dir/template_to_original.sh $env_prop_file $kdc_dir/kadm5.acl.template > /var/kerberos/krb5kdc/kadm5.acl
sh $common_dir/template_to_original.sh $env_prop_file $kdc_dir/kdc.conf.template > /var/kerberos/krb5kdc/kdc.conf
sh $common_dir/template_to_original.sh $env_prop_file $kdc_dir/principal_names.template > $kdc_dir/principal_names
sh $common_dir/template_to_original.sh $env_prop_file $kdc_dir/kdc1-network.template > /etc/sysconfig/network 

## Initialize the database for the Realm
kdb5_util -r $REALM create -s -P $kdc_password

## Set runlevel and Start the Kerberos services
chkconfig --level 2345 krb5kdc on
chkconfig --level 2345 kadmin on
service krb5kdc start
service kadmin start

## Create the keytabs directory
mkdir -p $KEYTABS_DIR

## Create necessary principals and keytabs
awk -F, '{ print "addprinc  -randkey ", $1 }' < $kdc_dir/principal_names | kadmin.local
awk -F, '{ print "ktadd -k ", $2," ", $1 }' < $kdc_dir/principal_names | kadmin.local

## All the below steps are required for slave to be in sync with master
mkdir -p /nyl/scripts/
#sh $common_dir/template_to_original.sh $env_prop_file $kdc_dir/kpropd.acl.template > /var/kerberos/krb5kdc/kpropd.acl
#sh $common_dir/template_to_original.sh $env_prop_file $kdc_dir/kdc_dump.sh.template > /nyl/scripts/kdc_dump.sh

## Rename keytab
cp $KEYTABS_DIR/kdc1.keytab /etc/krb5.keytab

## Start kprop service which will transfer the database from Master to Slave
chkconfig --level 2345 kprop on
service kprop start

## Change the permission of the keytabs files
chmod 666 $KEYTABS_DIR/*

##EDM-EIS Oneway Trust KDC 
#echo "add_principal -pw $oneway_trust_password $ONEWAY_TRUST_PRINCIPAL_NAME"  | kadmin.local
#echo "add_principal -pw $oneway_trust_password $TWOWAY_TRUST_PRINCIPAL_NAME"  | kadmin.local

#sudo reboot


#!/bin/bash
md5sum_val="${1}"
env_val="${2}"
cert_md5sum=`md5sum /nyl/eis/ms/app/${env_val}.eis.nylcloud.com.jks | awk '{print $1}'`
if [[ ${md5sum_val} != ${cert_md5sum} ]]; then
        echo "Error - checksum Failed ${cert_md5sum}"
fi

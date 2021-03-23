#!/bin/sh
#API_IP="$1"
API_NAME="$1"
DNS_NAME=`echo $API_NAME | cut -d/ -f3  | cut -d : -f1`
DNS_PORT=`echo $API_NAME |  cut -d/ -f3`
HEALTH_STATUS=`curl -sIk "${API_NAME}" | head -n 1 | awk '{print $2}'`
CERT_VALIDATE=`echo | openssl s_client -servername $DNS_NAME -connect $DNS_PORT 2>/dev/null | openssl x509 -noout -issuer -subject -dates | grep "notAfter" | awk '{print $4}'`

if [[ "$HEALTH_STATUS" = 200 ]] && [[ "$CERT_VALIDATE" = 2022 ]]; then 
echo "Health Status and Cert Validate is looks Good"
else
echo "Validation Failed"
fi

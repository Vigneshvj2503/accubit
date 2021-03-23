#!/bin/sh
#Description
#This script used to verify the ElasticSearch Restore Index Operation
#Validating the number of parameters
if [ "$#" -ne 0 ]; then
 echo "`date '+%Y-%m-%d %H:%M:%S'`: Please provide right number of arguments"
 echo "`date '+%Y-%m-%d %H:%M:%S'`: Usage: sh es_restore_index.sh"
 echo "`date '+%Y-%m-%d %H:%M:%S'`: Example: sh sh es_restore_index.sh snapshot_name index_name"
 exit 1
fi

#Variables
CURRENT_ENV=`hostname | cut -d'.' -f2`
ES_SNAPSHOT=`curl -s "https://${CURRENT_ENV}.elasticsearch.eis.nylcloud.com/_cat/snapshots/es-s3-repo?v&s=id" | grep "SUCCESS" | tail -n 1 | awk '{print $1}'`
ES_INDEX=`curl -s -XGET "https://${CURRENT_ENV}.elasticsearch.eis.nylcloud.com:443/_snapshot/es-s3-repo/$ES_SNAPSHOT?pretty" | grep client_consumer_name | sed 's/"//g' | sed 's/,//g' | tr -d "[:blank:]"`
ES_REPO=es-s3-repo
ES_ELB=https://${CURRENT_ENV}.elasticsearch.eis.nylcloud.com
FROM_ADDRESS=no-reply.ES-Restore-Index.${CURRENT_ENV}@newyorklife.com
TO_ADDRESS=EIS_DevOps_Team@newyorklife.com
#TO_ADDRESS=aravind_nithiyanandham@newyorklife.com

#Verify Actual Index Count
ACTUAL_INDEX_COUNT=`curl -XGET "${ES_ELB}/${ES_INDEX}/_count" | jq -r ".count"`

#Restore the Snapshot for single index
curl -sw "%{http_code}"  -s -XPOST "$ES_ELB/_snapshot/$ES_REPO/$ES_SNAPSHOT/_restore?pretty&wait_for_completion=true" -H  'Content-Type: application/json' -d '
 {
 "indices": "'${ES_INDEX}'",
 "rename_pattern": "'${ES_INDEX}'",
 "rename_replacement": "'sample_${ES_INDEX}'"
}'

sleep 5

RESTORED_INDEX_COUNT=`curl -XGET "${ES_ELB}/sample_${ES_INDEX}/_count" | jq -r ".count"`

if [[ "$RESTORED_INDEX_COUNT" -le "$ACTUAL_INDEX_COUNT"  ]]; then
	echo "Restored Index has been successful"
	mail  -r $FROM_ADDRESS -s "ES Restore Index Matched" $TO_ADDRESS <<< "ES Restore Index Matched PreCount:$ACTUAL_INDEX_COUNT,PostCount:$RESTORED_INDEX_COUNT and SnapshotName:$ES_SNAPSHOT  $(date +%x_%r)"
        sleep 5
	curl -XDELETE "${ES_ELB}/sample_${ES_INDEX}"
else
	mail  -r $FROM_ADDRESS -s "Issue in ES Restore Index" $TO_ADDRESS <<< "Restored Index Count is mismatch with Actual Index at $(date +%x_%r)"
	exit 1
fi



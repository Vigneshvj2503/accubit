#!/bin/bash
#Description: This automation script used to import mule xml files

if [ "$#" -lt 1 ] || [ "$#" -gt 3 ] || [ "$#" -lt 3 ]; then
  echo "Please provide right number of arguments"
  echo "Usage: sh mule-script.sh env xmlFilename jobname"
  echo "Example: sh mule-script.sh dev test-job.xml test-job"
  exit 1
fi

#variables
env=$1
xmlFilename=$2
jobname=$3


if [[ ${env} = "dev"  ]]; then
#sed -i s/\$anypointUserValue-${env}/mule_devops_int/g ${xmlFilename}
#sed -i s/\$anypointPassValue-${env}/Muledevopsint1!/g ${xmlFilename}
#sed -i s/\$anypointPlatformSecretValue-${env}/a7e2755E11Eb49D4B04a6D84920fF6F0/g ${xmlFilename}
#sed -i s/\$anypointPlatformClientValue-${env}/4a5ff9cd80fb424e8b70b03a0edb2ef6/g ${xmlFilename}
#sed -i s/\$keystorePassValue-${env}/nylcorp/g ${xmlFilename}
#sed -i s/\$ldapServerUserPasswordValue-${env}/My54nYLAd32/g ${xmlFilename}
#java -jar jenkins-cli.jar -s http://jenkins.eis.nonprod.nylcloudlabs.com/  -auth aravind_nithiyanandham@newyorklife.com:ffff2bc6d31b7f0f409045aea695454c create-job /mule-jobs/dev/newbatch_3/${jobname} < ${xmlFilename}
java -jar jenkins-cli.jar -auth "aravind_nithiyanandham@newyorklife.com:ffff2bc6d31b7f0f409045aea695454c" -s http://jenkins.eis.nonprod.nylcloudlabs.com/ build mule-jobs/${env}/newbatch_3/${jobname}
echo "`date '+%Y-%m-%d %H:%M:%S'`:Script has been completed"
exit 1
fi

if [[ ${env} = "int2"  ]]; then
sed -i s/\$anypointUserValue-${env}/mule_devops_int/g ${xmlFilename}
sed -i s/\$anypointPassValue-${env}/Muledevopsint1!/g ${xmlFilename}
sed -i s/\$anypointPlatformSecretValue-${env}/2eD9FD3400D140De8aa928cC5a212632/g ${xmlFilename}
sed -i s/\$anypointPlatformClientValue-${env}/21d61fc4a60147509c4fbd80100aea1f/g ${xmlFilename}
sed -i s/\$keystorePassValue-${env}/NpMule123!/g ${xmlFilename}
sed -i s/\$ldapServerUserPasswordValue-${env}/My54nYLAd32/g ${xmlFilename}
java -jar jenkins-cli.jar -s http://jenkins.eis.nonprod.nylcloudlabs.com/  -auth t15k84h:ffff2bc6d31b7f0f409045aea695454c create-job /mule-jobs/restservices/${env}/non-actional/${jobname} < ${xmlFilename}

java -jar jenkins-cli.jar -s http://jenkins.eis.nonprod.nylcloudlabs.com/  -auth t15k84h:ffff2bc6d31b7f0f409045aea695454c build-job /mule-jobs/restservices/${env}/non-actional/${jobname} < ${xmlFilename}

echo "`date '+%Y-%m-%d %H:%M:%S'`:Script has been completed"
exit 1
fi

if [[ ${env} = "qa2"  ]]; then
sed -i s/\$anypointUserValue-${env}/mule_devops_qa/g ${xmlFilename}
sed -i s/\$anypointPassValue-${env}/Muledevopsint1!/g ${xmlFilename}
sed -i s/\$anypointPlatformSecretValue-${env}/d21Cf4c714c44ce2a66c7DE18fCb70A9/g ${xmlFilename}
sed -i s/\$anypointPlatformClientValue-${env}/e58e615e50664d11b55a8e5f7140756a/g ${xmlFilename}
sed -i s/\$keystorePassValue-${env}/NpMule123!/g ${xmlFilename}
sed -i s/\$ldapServerUserPasswordValue-${env}/My54nYLAd32/g ${xmlFilename}
java -jar jenkins-cli.jar -s http://jenkins.eis.nonprod.nylcloudlabs.com/  -auth t15k84h:115baac9d9844d7fad173605ae2c522e6e create-job /mule-jobs/soapservices/${env}/non-actional/eis-clientemailmaintenance2/${jobname} < ${xmlFilename}

java -jar jenkins-cli.jar -s http://jenkins.eis.nonprod.nylcloudlabs.com/  -auth t15k84h:115baac9d9844d7fad173605ae2c522e6e  build /mule-jobs/soapservices/${env}/non-actional/eis-clientemailmaintenance2/${jobname} < ${xmlFilename}

echo "`date '+%Y-%m-%d %H:%M:%S'`:Script has been completed"
exit 1
fi

if [[ ${env} = "stg"  ]]; then
sed -i s/\$anypointUserValue-${env}/mule_devops_stg/g ${xmlFilename}
sed -i s/\$anypointPassValue-${env}/Muledevopsqa1!/g ${xmlFilename}
sed -i s/\$anypointPlatformSecretValue-${env}/a82966c774144e47880fbbFee306D8e9/g ${xmlFilename}
sed -i s/\$anypointPlatformClientValue-${env}/8ed28e05a90f42be81d5b9ed229b80c3/g ${xmlFilename}
sed -i s/\$keystorePassValue-${env}/nylcorp/g ${xmlFilename}
sed -i s/\$ldapServerUserPasswordValue-${env}/My54nYLAd32/g ${xmlFilename}
java -jar jenkins-cli.jar -s http://jenkins.eis.nonprod.nylcloudlabs.com/  -auth aravind_nithiyanandham@newyorklife.com:ffff2bc6d31b7f0f409045aea695454c create-job /mule-jobs/${env}/${jobname} < ${xmlFilename}
echo "`date '+%Y-%m-%d %H:%M:%S'`:Script has been completed"
exit 1
fi


if [[ ${env} = "prod"  ]]; then
sed -i s/\$anypointUserValue/mule_devops/g ${xmlFilename}
sed -i s/\$anypointPassValue/Muledevopsqa1!/g ${xmlFilename}
sed -i s/\$anypointPlatformSecretValue/514539E6626F4b3398AaE71527694D2B/g ${xmlFilename}
sed -i s/\$anypointPlatformClientValue-${env}/6126fd09226b458397c6b9d06e98f264/g ${xmlFilename}
sed -i s/\$keystorePassValue-${env}/nylcorp/g ${xmlFilename}
sed -i s/\$ldapServerUserPasswordValue-${env}/My54nYLAd32/g ${xmlFilename}
java -jar jenkins-cli.jar -s http://jenkins.eis.nonprod.nylcloudlabs.com/  -auth aravind_nithiyanandham@newyorklife.com:ffff2bc6d31b7f0f409045aea695454c create-job /mule-jobs/${env}/${jobname} < ${xmlFilename}
echo "`date '+%Y-%m-%d %H:%M:%S'`:Script has been completed"
exit 1
fi


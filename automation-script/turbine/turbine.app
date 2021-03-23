APP_PATH="/nyl/eis/ms/app"
CURRENT_ENV=`hostname | cut -d'.' -f2`
HOSTNAME=`hostname`
RETVAL=0
APP_PARAMS="-Djavax.net.ssl.trustStore=${APP_PATH}/turbine-app/truststore.jks -Djavax.net.ssl.trustStoreType=jks -jar ${APP_PATH}/turbine-app/turbine-app.jar --spring.cloud.bootstrap.location=${APP_PATH}/turbine-app/bootstrap-${CURRENT_ENV}.yml --spring.profiles.active=${CURRENT_ENV} --server.port=8443 --spring.cloud.consul.discovery.hostname=${HOSTNAME} --spring.cloud.consul.discovery.instanceId=${HOSTNAME} --server.ssl.enabled=true --server.ssl.key-store-provider=SUN --server.ssl.key-store-type=jks --server.ssl.key-store=${APP_PATH}/turbine-app/keystore.jks --server.ssl.key-alias=service-cert --spring.cloud.consul.discovery.scheme=https --security.ignored=/turbine.stream"
SERVICE_NAME=turbine
PID_PATH_NAME=/var/run/turbine.pid
NODE=`hostname | cut -d '.' -f1 | tail -c 2`
FROM_ADDRESS=no-reply.turbine${NODE}.${CURRENT_ENV}@newyorklife.com
#TO_ADDRESS=EIS_DevOps_Team@newyorklife.com
TO_ADDRESS=aravind_nithiyanandham@newyorklife.com
MAIL_SEND_FLAG="true"

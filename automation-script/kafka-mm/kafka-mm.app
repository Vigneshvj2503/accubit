NODE=`hostname | cut -d '.' -f1 | tail -c 2`
CURRENT_ENV=`hostname | cut -d'.' -f2`
FROM_ADDRESS=no-reply.kafkahdf${NODE}.${CURRENT_ENV}@newyorklife.com
TO_ADDRESS=EIS_DevOps_Team@newyorklife.com
#TO_ADDRESS=Aravind_Nithiyanandham@newyorklife.com
MAIL_SEND_FLAG="true"

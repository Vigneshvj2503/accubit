#! /bin/sh
# /etc/init.d/kafka: start the kafka daemon.

# chkconfig: 23456 85 15
# description: kafka


case "$1" in
start)
        sh /nyl/app/mirrormaker/bin/kafka-mm-service.sh start
        ;;
stop)
	sh /nyl/app/mirrormaker/bin/kafka-mm-service.sh stop
        ;;

reload)
       sh /nyl/app/mirrormaker/bin/kafka-mm-service.sh reload
        ;;
auto)
	sh /nyl/app/mirrormaker/bin/kafka-mm-service.sh auto
	;;

restart)
      sh /nyl/app/mirrormaker/bin/kafka-mm-service.sh restart
        ;;

status)
        sh /nyl/app/mirrormaker/bin/kafka-mm-service.sh status
        ;;
*)

echo $"Usage: $0 {start|stop|reload|restart|status|auto}"
exit 1
esac

exit $?

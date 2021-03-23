#! /bin/sh
# /etc/init.d/kafka: start the kafka daemon.

# chkconfig: - 80 20
# description: kafka

KAFKA_MM_HOME=/nyl/app/mirrormaker
KAFKA_USER=kafka
KAFKA_MM_SCRIPT=$KAFKA_MM_HOME/bin/kafka-mirror-maker.sh
KAFKA_MM_CONFIG="--consumer.config $KAFKA_MM_HOME/conf/mm-consumer.properties --producer.config $KAFKA_MM_HOME/conf/mm-producer.properties --whitelist='com.newyorklife.eis.*' --new.consumer --num.streams 3"
KAFKA_MM_CONSOLE_LOG=$KAFKA_MM_HOME/logs/mirrormaker.log
export KAFKA_HEAP_OPTS="-Xms1G -Xmx8G"

PATH=/bin:/usr/bin:/sbin:/usr/sbin:/usr/local/bin

prog="kafka-mirrormaker"
DESC="kafka daemon"

RETVAL=0
STARTUP_WAIT=20
SHUTDOWN_WAIT=20

KAFKA_MM_PIDFILE=$KAFKA_MM_HOME/kafka-mm.pid


# Source function library.
. /etc/init.d/functions
. /etc/sysconfig/kafka-mm.app
. /etc/sysconfig/kafka-mm.functions

start() {
  echo -n $"Starting $prog: "

        # Create pid file
        if [ -f $KAFKA_MM_PIDFILE ]; then
                read ppid < $KAFKA_MM_PIDFILE
                if [ `ps --pid $ppid 2> /dev/null | grep -c $ppid 2> /dev/null` -eq '1' ]; then
                        echo -n "$prog is already running"
                        failure
                        echo
                        return 1
                else
                      rm -f $KAFKA_MM_PIDFILE
                fi
        fi

        mv $KAFKA_MM_CONSOLE_LOG "${KAFKA_MM_CONSOLE_LOG}.`date +%Y%m%d%H%M%S`"
        mkdir -p $(dirname $KAFKA_MM_PIDFILE)
        chown $KAFKA_USER $(dirname $KAFKA_MM_PIDFILE) || true

        # Run daemon
        cd $KAFKA_HOME
       su $KAFKA_USER -c "nohup sh $KAFKA_MM_SCRIPT $KAFKA_MM_CONFIG 2>&1 >> $KAFKA_MM_CONSOLE_LOG 2>&1 & echo \$! > $KAFKA_MM_PIDFILE"
        count=0
        launched=false

        until [ $count -gt $STARTUP_WAIT ]
        do
                grep 'started' $KAFKA_MM_CONSOLE_LOG > /dev/null
                if [ $? -eq 0 ] ; then
                        launched=true
                        break
                fi
                sleep 1
                let count=$count+1;
        done

        success
        echo
        return 0
}


stop() {
	mail_grp
        echo -n $"Stopping $prog: "
        count=0;

        if [ -f $KAFKA_MM_PIDFILE ]; then
                read kpid < $KAFKA_MM_PIDFILE
                let kwait=$SHUTDOWN_WAIT

                # Try issuing SIGTERM
                kill -15 $kpid
                until [ `ps --pid $kpid 2> /dev/null | grep -c $kpid 2> /dev/null` -eq '0' ] || [ $count -gt $kwait ]
                        do
                        sleep 1
                        let count=$count+1;
                done

                if [ $count -gt $kwait ]; then
                        kill -9 $kpid
                fi
        fi

        rm -f $KAFKA_MM_PIDFILE
        #rm -f $KAFKA_MM_CONSOLE_LOG
        success
        echo
}

reload() {
        stop
        start
}

auto() {
	 start
	 mail_send "Kafka-mm-autostart" "Kafka MM service started by autorecovery script at $(date +%x_%r)"
	}

restart() {
        stop
	 mail_send "Kafka-mm-stop" "Kafka MM service stopped successfully at $(date +%x_%r)" &&
        start
	  mail_send "Kafka-mm-start" "Kafka MM service started successfully at $(date +%x_%r)"
}

status() {
        if [ -f $KAFKA_MM_PIDFILE ]; then
                read ppid < $KAFKA_MM_PIDFILE
                if [ `ps --pid $ppid 2> /dev/null | grep -c $ppid 2> /dev/null` -eq '1' ]; then
                        echo "$prog is running (pid $ppid)"
                        return 0
                else
                      echo "$prog dead but pid file exists"
                        return 1
                fi
        fi
        echo "$prog is not running"
        return 3
}

case "$1" in
start)
        start
	mail_send "Kafka-mm-start" "Kafka MM service started successfully at $(date +%x_%r)"
        ;;

stop)
        stop
	mail_send "Kafka-mm-stop" "Kafka MM service stopped successfully at $(date +%x_%r)"
        ;;

reload)
        reload
        ;;
auto)
	auto
	;;

restart)
       restart
        ;;

status)
        status
        ;;
*)

echo $"Usage: $0 {start|stop|reload|restart|status|auto}"
exit 1
esac

exit $?


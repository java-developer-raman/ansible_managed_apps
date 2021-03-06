#!/bin/bash
#
#
### BEGIN INIT INFO
# Provides:          Kibana
# Required-Start:    $network $remote_fs $named
# Required-Stop:     $network $remote_fs $named
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Starts Kibana
# Description:       Starts Kibana using start-stop-daemon
### END INIT INFO

PATH=/bin:/usr/bin:/sbin:/usr/sbin
NAME=kibana
DESC="Kibana Server"
JAVA_HOME={{ java_home }}
if [ `id -u` -ne 0 ]; then
	echo "You need root privileges to run this script"
	exit 1
fi


. /lib/lsb/init-functions

# Directory where the Kibana binary distribution resides
KIBANA_HOME={{kibana_home}}

# Kibana PID file directory
PID_DIR="{{kibana_home}}/bin"

# Define other required variables
PID_FILE="$PID_DIR/$NAME.pid"
DAEMON=$KIBANA_HOME/bin/kibana

export JAVA_HOME

if [ ! -x "$DAEMON" ]; then
	echo "The Kibana startup script does not exists or it is not executable, tried: $DAEMON"
	exit 1
fi

checkJava() {
	if [ -x "$JAVA_HOME/bin/java" ]; then
		JAVA="$JAVA_HOME/bin/java"
	else
		JAVA=`which java`
	fi

	if [ ! -x "$JAVA" ]; then
		echo "Could not find any executable java binary. Please install java in your PATH or set JAVA_HOME"
		exit 1
	fi
}

case "$1" in
  start)
	checkJava

	log_daemon_msg "Starting $DESC"

	pid=`pidofproc -p $PID_FILE kibana`
	if [ -n "$pid" ] ; then
		log_begin_msg "Already running."
		log_end_msg 0
		exit 0
	fi

	# Ensure that the PID_DIR exists (it is cleaned at OS startup time)
	if [ -n "$PID_DIR" ] && [ ! -e "$PID_DIR" ]; then
		mkdir -p "$PID_DIR" && chown {{user_name}}:{{group_name}} "$PID_DIR"
	fi
	if [ -n "$PID_FILE" ] && [ ! -e "$PID_FILE" ]; then
		touch "$PID_FILE" && chown {{user_name}}:{{group_name}} "$PID_FILE"
	fi

	# Start Daemon
	start-stop-daemon --start --user {{user_name}} -c {{user_name}} --pidfile "$PID_FILE" --make-pidfile --background --exec $DAEMON
	return=$?
	if [ $return -eq 0 ]; then
		i=0
		timeout=10
		# Wait for the process to be properly started before exiting
		until { kill -0 `cat "$PID_FILE"`; } >/dev/null 2>&1
		do
			sleep 1
			i=$(($i + 1))
			if [ $i -gt $timeout ]; then
				log_end_msg 1
				exit 1
			fi
		done
	fi
	log_end_msg $return
	exit $return
	;;
  stop)
	log_daemon_msg "Stopping $DESC"

	if [ -f "$PID_FILE" ]; then
		start-stop-daemon --stop --pidfile "$PID_FILE" \
			--remove-pidfile \
			--quiet \
			--retry forever/TERM/20 > /dev/null
		if [ $? -eq 1 ]; then
			log_progress_msg "$DESC is not running but pid file exists, cleaning up"
		elif [ $? -eq 3 ]; then
			PID="`cat $PID_FILE`"
			log_failure_msg "Failed to stop $DESC (pid $PID)"
			exit 1
		fi
		rm -f "$PID_FILE"
	else
		log_progress_msg "(not running)"
	fi
	log_end_msg 0
	;;
  status)
	status_of_proc -p $PID_FILE kibana kibana && exit 0 || exit $?
	;;
  restart|force-reload)
	if [ -f "$PID_FILE" ]; then
		$0 stop
	fi
	$0 start
	;;
  *)
	log_success_msg "Usage: $0 {start|stop|restart|force-reload|status}"
	exit 1
	;;
esac

exit 0
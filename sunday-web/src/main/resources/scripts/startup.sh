#!/bin/sh
#-------------------------------------------------------------------------------------------------------------
#该脚本的使用方式为-->[sh startup.sh]
#该脚本可在服务器上的任意目录下执行,不会影响到日志的输出位置等
#-------------------------------------------------------------------------------------------------------------
if [ ! -n "$JAVA_HOME" ]; then
	export JAVA_HOME="/usr/java/jdk1.7.0_79"
fi

#-------------------------------------------------------------------------------------------------------------
#       系统运行参数
#-------------------------------------------------------------------------------------------------------------
DIR=$(cd "$(dirname "$0")"; pwd)
APP_HOME=${DIR}/..
APP_CONF=${APP_CONF}/conf
CLASSPATH=${APP_CONF}
APP_LOG=${APP_HOME}/logs
APP_MAIN=com.sunday.AppServerMain
APP_IP=$(ifconfig  | grep 'inet addr:'| awk '{ print $2}'|tr -d "addr:"|head -1)

JAVA_OPTS="$JAVA_OPTS -Duser.timezone=GMT+0 -server -Xms2048m -Xmx4096m -XX:ParallelGCThreads=10 -XX:+UseConcMarkSweepGC -XX:MaxGCPauseMillis=850 -Xloggc:$APP_LOG/gc.log -Dfile.encoding=UTF-8"
JAVA_OPTS="$JAVA_OPTS -Dlog.path=$APP_LOG"
JAVA_OPTS="$JAVA_OPTS -Dbase.path=$APP_HOME"
JAVA_OPTS="$JAVA_OPTS -Djava.rmi.server.hostname=$APP_IP"
JAVA_OPTS="$JAVA_OPTS -Ddisconf.conf=$APP_CONF/config.properties"
#JAVA_OPTS="$JAVA_OPTS -Dcom.sun.management.jmxremote.port=6667 -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.ssl=false  -XX:+UnlockCommercialFeatures -XX:+FlightRecorder"

echo "JAVA_HOME="$JAVA_HOME
echo "CLASSPATH="$CLASSPATH
echo "JAVA_OPTS="$JAVA_OPTS

#-------------------------------------------------------------------------------------------------------------
#   程序开始
#-------------------------------------------------------------------------------------------------------------
for appJar in "$APP_HOME"/lib/*.jar;
do
   CLASSPATH="$CLASSPATH":"$appJar"
done
PID=0
nohup=$1

getPID(){
    javaps=`$JAVA_HOME/bin/jps -l | grep $APP_MAIN`
    if [ -n "$javaps" ]; then
        PID=`echo $javaps | awk '{print $1}'`
    else
        PID=0
    fi
}

startup(){
    getPID
    echo "================================================================================================================"
    if [ $PID -ne 0 ]; then
        echo "$APP_MAIN already started(PID=$PID)"
        echo "================================================================================================================"
    else
        echo -ne "Starting $APP_MAIN\033[5m...\033[0m"
         if [ ! -d "$APP_LOG" ]; then
            mkdir "$APP_LOG"
         fi
        if [ x$nohup != x-n ]; then
                nohup $JAVA_HOME/bin/java $JAVA_OPTS -classpath $CLASSPATH $APP_MAIN > /dev/null 2>&1 &
        else
                nohup $JAVA_HOME/bin/java $JAVA_OPTS -classpath $CLASSPATH $APP_MAIN > $APP_LOG/nohup.log 2>&1 &
        fi
        sleep 3
		echo -ne "\b\b\b"
        getPID
        if [ $PID -ne 0 ]; then
            echo "(PID=$PID)[Success]"
            echo "================================================================================================================"
        else
            echo "[Failed]"
            echo "================================================================================================================"
        fi
    fi
}

startup
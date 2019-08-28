#!/bin/sh
if [ ! -n "$JAVA_HOME" ]; then
	export JAVA_HOME="/usr/java/jdk1.7.0_79"
fi
APP_MAIN=com.sunday.AppServerMain
PID=0

getPID(){
    javaps=`$JAVA_HOME/bin/jps -l | grep $APP_MAIN`
    if [ -n "$javaps" ]; then
        PID=`echo $javaps | awk '{print $1}'`
    else
        PID=0
    fi
}

shutdown(){
    getPID

    if [ $PID -ne 0 ]; then
       echo -ne "Stopping $APP_MAIN(PID=$PID)\033[5m...\033[0m"

       doshutdown
    else
        echo "$APP_MAIN is not running"
        echo "================================================================================================================"
    fi
}

doshutdown(){
	getPID
	if [ $PID -eq 0 ]; then
		echo -ne "\b\b\b[Success]\n"
	else
        kill -15 $PID

		#等待最长时间，超过将强制kill
        seconds_left=40
		while ([ $seconds_left -gt 0 ] && [ $PID -gt 0 ]);do  
		    if [ $seconds_left -lt 10 ]; then
				echo -ne " "
			fi 
         	echo -n $seconds_left  
			sleep 1 
			echo -ne "\b\b"
			 
			seconds_left=$(($seconds_left - 1))  
			getPID
		done 
		 
		if ([ $PID -gt 0 ]); then
			kill -9 $PID
			echo -ne "\b\b\b[kill -9 Success]\n"
		else		 
			echo -ne "\b\b\b[Success]\n"
		fi
	fi
}
shutdown

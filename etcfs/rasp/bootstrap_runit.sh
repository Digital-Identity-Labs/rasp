#!/bin/sh
## Script by Sanj Ambalavanar
##   (https://sanjeevan.co.uk/blog/running-services-inside-a-container-using-runit-and-alpine-linux)
## Adjusted to work on Debian

shutdown() {
  echo "Shutting down services..."

  ## First shutdown any service started by runit
  for _srv in $(ls -1 /etc/service); do
    sv force-stop $_srv
  done

  ## Shutdown runsvdir command
  kill -HUP $RUNSVDIR
  wait $RUNSVDIR

  # give processes time to stop
  sleep 0.5

  # kill any other processes still running in the container
  for _pid  in $(ps -eo pid | grep -v PID  | tr -d ' ' | grep -v '^1$' | head -n -6); do
    timeout -t 5 /bin/sh -c "kill $_pid && wait $_pid || kill -9 $_pid"
  done
  exit
}

# Store environment variables
export > /etc/envvars

PATH=/usr/local/bin:/usr/local/sbin:/bin:/sbin:/usr/bin:/usr/sbin:/usr/X11R6/bin

## Run all scripts in the scripts folder. Once.
/bin/run-parts /etc/scripts

## Start the actual services
exec env - PATH=$PATH runsvdir -P /etc/service &

RUNSVDIR=$!
echo "Started runsvdir, PID is $RUNSVDIR"
echo "Waiting for processes to start...."

sleep 5
for _srv in $(ls -1 /etc/service); do
    sv status $_srv
done

## Catch shutdown signals and run the shutdown function
trap shutdown TERM HUP QUIT INT
wait $RUNSVDIR

shutdown
#!/bin/bash

# Runs command and creates lock file
# for it, so you are unable to start multiple same commands
# Usage
# locking.sh sleep 10
# locking.sh echo "test"

if [ "`which md5sum`" == "" ];
then
  echo "md5sum is not installed";
  exit 1
fi

EXECUTE_COMMAND=$@
COMMAND_LOCK_FILE="/tmp/`whoami`-`echo $EXECUTE_COMMAND | md5sum | awk '{ print $1 }'`.lock"

if [ -f "${COMMAND_LOCK_FILE}" ];
then
  echo "Lock file exists ${COMMAND_LOCK_FILE}";
  kill -0 $(cat $COMMAND_LOCK_FILE)
  if [ $? -eq 0 ];
  then
    echo "Process already running under `cat $COMMAND_LOCK_FILE` pid"
    exit 0
  fi
fi

echo "Running ${EXECUTE_COMMAND}"
eval $EXECUTE_COMMAND &
echo $! > $COMMAND_LOCK_FILE
wait

rm $COMMAND_LOCK_FILE

exit 0

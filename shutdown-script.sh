#!/bin/sh
export SCRIPT_DIR=$(/usr/bin/dirname "$0")
. "${SCRIPT_DIR}/host.config.sh"


echo
echo Environment
env
echo


${SCRIPT_DIR}/esxi-stop-all-datastore-vms.sh
							

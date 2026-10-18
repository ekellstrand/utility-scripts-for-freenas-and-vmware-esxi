#!/bin/sh
################################################################################
#
# Command-line parameters: user_id esxi_host_name datastore_name
#
# Gracefully powers down all guest virtual machines in a particular datastore (datastore_name)
# on remote VMware ESXi server (esxi_host_name) using given user credentials (user_id).
#
################################################################################


export SCRIPT_DIR=$(/usr/bin/dirname "$0")
. "${SCRIPT_DIR}/host.config.sh"

is_active=0
waitdelay=15

#set -x
echo VMS_TO_START=$VMS_TO_START
VMS_TO_STOP=$(printf '%s\n' ${VMS_TO_START} |/usr/bin/tac)
echo VMS_TO_STOP=$VMS_TO_STOP

for vmName in $VMS_TO_STOP; do
  echo "$(/usr/bin/date): Processing vm: $vmName"
	${SCRIPT_DIR}/esxi-stop-vm.sh ${esxiuser} ${esxihost} ${vmName}
	
done

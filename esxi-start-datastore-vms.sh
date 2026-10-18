#!/bin/sh
################################################################################
#
# Command-line parameters: --none--
#
# Start specific guest virtual machines
#
################################################################################

# Edit to suit your needs and environment

export SCRIPT_DIR=$(/usr/bin/dirname "$0")
. "${SCRIPT_DIR}/host.config.sh"

logfile=${logdir}/esxi-rescan-datastores.log

is_active=0
waitdelay=15

#set -x

sleepBeforeVmStart=1
for vmName in $VMS_TO_START; do
  if [ $sleepBeforeVmStart -eq 1 ]; then
  	sleepBeforeVmStart=0
	else
		# Only sleep between each VM - don't waste time with an extra sleep at the beginning or end
		echo "$(/usr/bin/date): Sleeping $waitdelay seconds before starting next VM"
		/usr/bin/sleep $waitdelay
  fi
  
  echo "$(/usr/bin/date): Processing vm: $vmName"
	${SCRIPT_DIR}/esxi-start-vm.sh ${esxiuser} ${esxihost} ${vmName} || sleepBeforeVmStart=1
	
done

#${SCRIPT_DIR}/esxi-start-vm.sh ${esxiuser} ${esxihost} Orion
#sleep $waitdelay
#${SCRIPT_DIR}/esxi-start-vm.sh ${esxiuser} ${esxihost} aphrodite

#if [ $is_active -ne 0 ]; then
#  echo "Pausing $waitdelay seconds before starting virtual machines..." >> $logfile
#  sleep $waitdelay
#  
#  if [ "${freenashost}" = "truenas" ]; then
#    ${SCRIPT_DIR}/esxi-start-vm.sh root felix adonis  >> $logfile
#    ${SCRIPT_DIR}/esxi-start-vm.sh root felix aphrodite  >> $logfile
#  fi
#fi


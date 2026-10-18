#!/bin/sh
################################################################################
#
# Command-line parameters: --none--
#
# Gracefully powers down all guest virtual machines in the FreeNAS datastores
#
################################################################################

export SCRIPT_DIR=$(/usr/bin/dirname "$0")
. "${SCRIPT_DIR}/host.config.sh"

logfile=${logdir}/esxi-stop-all-vms.log

echo "$(date): Shut down virtual machines on ESXi host ${esxihost}, FreeNAS server ${freenashost}" | tee ${logfile}

for datastore in $datastores; do
  ${SCRIPT_DIR}/esxi-stop-all-datastore-vms.sh root ${esxihost} ${datastore} >> ${logfile}
done


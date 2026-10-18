#!/bin/sh

################################################################################
#
# Command-line parameters: --none--
#
# Configures iSCSI adapter in ESXi for this TrueNAS host
#
################################################################################

export SCRIPT_DIR=$(/usr/bin/dirname "$0")
. "${SCRIPT_DIR}/host.config.sh"

logfile=${logdir}/esxi-rescan-datastores.log


#set -x

echo "$(/usr/bin/date): Existing iSCSI Dynamic Targets on ESXi Host ${esxihost}"
/usr/bin/ssh ${sshIdentityOpt} ${esxiuser}@"${esxihost}" esxcli iscsi adapter discovery sendtarget list
echo

echo "$(/usr/bin/date): Configuring iSCSI adapter ${ISCSI_ADAPTER_NAME} on ESXi host ${esxihost}"
/usr/bin/ssh ${sshIdentityOpt} ${esxiuser}@"${esxihost}" esxcli iscsi adapter discovery sendtarget add --adapter=${ISCSI_ADAPTER_NAME} --address=${ISCCI_SERVER_ADDRESS}
echo

echo "$(/usr/bin/date): Final iSCSI Dynamic Targets on ESXi host ${esxihost}"
/usr/bin/ssh ${sshIdentityOpt} ${esxiuser}@"${esxihost}" esxcli iscsi adapter discovery sendtarget list
echo
/usr/bin/ssh ${sshIdentityOpt} ${esxiuser}@"${esxihost}" esxcli iscsi adapter target list
echo

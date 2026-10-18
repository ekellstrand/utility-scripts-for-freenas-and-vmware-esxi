#!/bin/sh

################################################################################
#
# Command-line parameters: --none--
#
# Forces a TrueNAS VM's ESXi host to rescan its datastores
#
################################################################################

export SCRIPT_DIR=$(/usr/bin/dirname "$0")
. "${SCRIPT_DIR}/host.config.sh"

logfile=${logdir}/esxi-rescan-datastores.log


#set -x

echo "$(/usr/bin/date): Before Rescan - Orion data disk: ll /vmfs/volumes/dsOrionData/Orion/Orion.vmdk"
/usr/bin/ssh ${sshIdentityOpt} ${esxiuser}@"${esxihost}" ls -l /vmfs/volumes/dsOrionData/Orion/Orion.vmdk
echo "$(/usr/bin/date): Before Rescan - Orion datastore: ll /vmfs/volumes/dsOrionData"
/usr/bin/ssh ${sshIdentityOpt} ${esxiuser}@"${esxihost}" ls -l /vmfs/volumes/dsOrionData
echo "$(/usr/bin/date): Before Rescan - All datastores: ll /vmfs/volumes/"
/usr/bin/ssh ${sshIdentityOpt} ${esxiuser}@"${esxihost}" ls -l /vmfs/volumes/dsOrionData
echo
echo
echo


echo "$(/usr/bin/date): Existing Adapter Targets on ESXi Host ${esxihost}"
/usr/bin/ssh ${sshIdentityOpt} ${esxiuser}@"${esxihost}" esxcli iscsi adapter target list
echo

echo "$(/usr/bin/date): Rescanning iSCSI adapter ${ISCSI_ADAPTER_NAME} on ESXi host ${esxihost}" 
/usr/bin/ssh ${sshIdentityOpt} ${esxiuser}@"${esxihost}" esxcli storage core adapter rescan --adapter=${ISCSI_ADAPTER_NAME}
echo


#TODO:  Implement WaitForVolumeToAppear function instead of sleeping
echo "$(/usr/bin/date): After Rescan - Orion data disk: ll /vmfs/volumes/dsOrionData/Orion/Orion.vmdk"
/usr/bin/ssh ${sshIdentityOpt} ${esxiuser}@"${esxihost}" ls -l /vmfs/volumes/dsOrionData/Orion/Orion.vmdk
echo "$(/usr/bin/date): After Rescan - Orion datastore: ll /vmfs/volumes/dsOrionData"
/usr/bin/ssh ${sshIdentityOpt} ${esxiuser}@"${esxihost}" ls -l /vmfs/volumes/dsOrionData
echo "$(/usr/bin/date): After Rescan - All datastores: ll /vmfs/volumes/"
/usr/bin/ssh ${sshIdentityOpt} ${esxiuser}@"${esxihost}" ls -l /vmfs/volumes/dsOrionData
echo
echo
echo

echo "$(/usr/bin/date): Sleeping 5 seconds"
sleep 5
echo "$(/usr/bin/date): Done Sleeping"

echo "$(/usr/bin/date): After Sleep - Orion data disk: ll /vmfs/volumes/dsOrionData/Orion/Orion.vmdk"
/usr/bin/ssh ${sshIdentityOpt} ${esxiuser}@"${esxihost}" ls -l /vmfs/volumes/dsOrionData/Orion/Orion.vmdk
echo "$(/usr/bin/date): After Sleep - Orion datastore: ll /vmfs/volumes/dsOrionData"
/usr/bin/ssh ${sshIdentityOpt} ${esxiuser}@"${esxihost}" ls -l /vmfs/volumes/dsOrionData
echo "$(/usr/bin/date): After Sleep - All datastores: ll /vmfs/volumes/"
/usr/bin/ssh ${sshIdentityOpt} ${esxiuser}@"${esxihost}" ls -l /vmfs/volumes/dsOrionData
echo
echo
echo

echo "$(/usr/bin/date): Final devices for Adapter ${ISCSI_ADAPTER_NAME} on ESXi Host ${esxihost}"
/usr/bin/ssh ${sshIdentityOpt} ${esxiuser}@"${esxihost}" esxcli storage core adapter device list --adapter=${ISCSI_ADAPTER_NAME}
echo

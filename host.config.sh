#!/bin/sh
export SCRIPT_DIR=$(/usr/bin/dirname "$0")

export logdir="${SCRIPT_DIR}"
##### export esxihost=vmware

export esxiuser=root
export sshIdentityOpt="-i /root/.ssh/kellstrand.com/id_rsa.server-ekellstrand"

##### export ISCSI_ADAPTER_NAME=vmhba64
##### export ISCCI_SERVER_ADDRESS=192.168.16.9




################################################################################
################################################################################
# 
# Define host-specific values for these variables:
# 
# freenashost : defaults to short hostname returned by 'hostname -s'
# esxihost    : user-defined  
# datastores  : user-defined  
# logdir      : user-defined (and must exist before use)  
#
################################################################################
################################################################################

freenashost=$(hostname -s)

# Edit to suit your needs and environment

# This is an example, showing the setup for these AIO systems:
#
# FreeNAS host 'bacon' running on ESXi host 'fritz' with datastores 'BACON' and 'BACON_BLOCK'
# FreeNAS host 'boomer' running on ESXi host 'felix' with datastore 'BOOMER'
#
# Configured to store logs in unique directories specified by 'logdir'

if [ "${freenashost}" = "truenas" ]; then
  export esxihost=vmware
  export datastores="BACON BACON_BLOCK"
  export logdir="${SCRIPT_DIR}"
  export ISCSI_ADAPTER_NAME=vmhba64
  export ISCCI_SERVER_ADDRESS=192.168.16.9
  export VMS_TO_START="Orion Aurora1"
elif [ "${freenashost}" = "boomer" ]; then
  export esxihost=felix
  export datastores="BOOMER"
  export logdir="${SCRIPT_DIR}"
  export ISCCI_SERVER_ADDRESS=192.168.16.9
  export VMS_TO_START="Orion Aurora"
else 
  echo "Undefined system!"
  exit 1
fi


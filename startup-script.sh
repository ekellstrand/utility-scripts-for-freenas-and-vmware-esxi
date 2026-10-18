#!/bin/sh

export SCRIPT_DIR=$(/usr/bin/dirname "$0")
. "${SCRIPT_DIR}/host.config.sh"


echo
echo Environment
/usr/bin/env | /usr/bin/sort --ignore-case
echo

${SCRIPT_DIR}/esxi-config-iSCSI.sh
${SCRIPT_DIR}/esxi-rescan-iSCSI.sh
${SCRIPT_DIR}/esxi-start-datastore-vms.sh


#!/bin/sh
################################################################################
#
# Command-line parameters: user_id esxi_host_name vmx_base_filename
#
# Stop guest virtual machine with vmx file (vmx_base_filename'.vmx') on remote
# VMware ESXi server (esxi_host_name) using given user credentials (user_id)
#
################################################################################

# Check for invocation errors

if [ $# -ne 3 ]; then
  echo "$0: error! Not enough arguments"
  echo "Usage is: $0 user_id esxi_host_name vmx_filename"
  echo "Only specify the vmx basefilename; leave off the '.vmx' extension"
  exit 1
fi

export SCRIPT_DIR=$(/usr/bin/dirname "$0")
. "${SCRIPT_DIR}/host.config.sh"
. "${SCRIPT_DIR}/esxi.config.sh"

# Gather command-line arguments for user ID, hostname, and datastore name:

esxiuser=$1
esxihost=$2
vmxname=$3

export guestvmid=$(/usr/bin/ssh ${sshIdentityOpt} "${esxiuser}"@"${esxihost}" vim-cmd vmsvc/getallvms | /usr/bin/grep "/${vmxname}.vmx" | /usr/bin/awk '$1 ~ /^[0-9]+$/ {print $1}')
echo "guestvmid=$guestvmid"

vmCount=$(echo -n "$guestvmid" | /usr/bin/wc -w)

echo "vmCount=$vmCount"

if [ -z "${guestvmid}" ]; then
	echo "Failed to find vm: ${vmxname}.vmx"
	echo "All VMs"
	/usr/bin/ssh ${sshIdentityOpt} "${esxiuser}"@"${esxihost}" vim-cmd vmsvc/getallvms
	exit 1
elif [ $vmCount -ne 1 ]; then
	echo "Error. Too many VMs matched name ${vmxname}.vmx:  ${guestvmid}"
	echo "All VMs"
	/usr/bin/ssh ${sshIdentityOpt} "${esxiuser}"@"${esxihost}" vim-cmd vmsvc/getallvms
	exit 3
else
	echo "Found the following VMs to stop: ${guestvmid}"
fi


echo "$(date): $0 ${esxiuser}@${esxihost} vmx=${vmxname}.vmx"

/usr/bin/ssh ${sshIdentityOpt} "${esxiuser}"@"${esxihost}" vim-cmd vmsvc/power.getstate ${guestvmid} | /usr/bin/grep -i "Powered off" > /dev/null 2<&1
l_status=$?

printf "VM [%s] status=[%s]\n" "${guestvmid}" "${l_status}"

if [ $l_status -eq 0 ]; then
  echo "Guest VM ID $guestvmid already powered off..."
	exit 2
else
  echo "Powering off guest VM ID $guestvmid..."
  #echo /usr/bin/ssh ${sshIdentityOpt} "${esxiuser}"@"${esxihost}" vim-cmd vmsvc/power.off ${guestvmid} 
  #> /dev/null 2<&1
  shutdown_guest_vm "$guestvmid"
fi

#!/bin/sh
# Based on Thomas Lindroth's shell script which sets up host for VM: http://sprunge.us/JUfS

TOTAL_CORES="0-5"
TOTAL_CORES_MASK="3F"	# 0-5, bitmask 0011 1111
HOST_CORES="0"			# Cores reserved for host
HOST_CORES_MASK="20"	# 0, bitmask 0010 0000
VIRT_CORES="1-5"		# Cores reserved for virtual machine(s)

VM_NAME="$1"
VM_ACTION="$2"

shield_vm () {
	cset set -c "$TOTAL_CORES" -s machine
	# Shield one core for host and rest for VM(s)
	cset shield --kthread on --cpu "$VIRT_CORES"
}

unshield_vm () {
	echo "$TOTAL_CORES_MASK" > /sys/bus/workqueue/devices/writeback/cpumask
	cset shield --reset
}

systemd_method () {

	if [ "$VM_ACTION" = "prepare" ]
	then
		echo "Started cpu isolation for domain \"${VM_NAME}\""
		systemctl set-property --runtime -- system.slice AllowedCPUs="$HOST_CORES"
		systemctl set-property --runtime -- user.slice AllowedCPUs="$HOST_CORES"
		systemctl set-property --runtime -- init.scope AllowedCPUs="$HOST_CORES"
		echo "Finished cpu isolation for domain \"${VM_NAME}\""
	elif [ "$VM_ACTION" = "release" ]
	then
		echo "Started cpu un-isolation for domain \"${VM_NAME}\""
		systemctl set-property --runtime -- system.slice AllowedCPUs="$TOTAL_CORES"
		systemctl set-property --runtime -- user.slice AllowedCPUs="$TOTAL_CORES"
		systemctl set-property --runtime -- init.scope AllowedCPUs="$TOTAL_CORES"
		echo "Finished cpu un-isolation for domain \"${VM_NAME}\""
	else
		echo "Invalid VM action" 2>&1
	fi

}

# non-systemd
cset_method() {

	cd $(dirname "$0")

	if [ "$VM_ACTION" = "prepare" ]
	then
		echo "Started cpu isolation for domain \"${VM_NAME}\""
		shield_vm
		# Reduce VM jitter: https://www.kernel.org/doc/Documentation/kernel-per-CPU-kthreads.txt
		sysctl vm.stat_interval=120

		sysctl -w kernel.watchdog=0
		# the kernel's dirty page writeback mechanism uses kthread workers. They introduce
		# massive arbitrary latencies when doing disk writes on the host and aren't
		# migrated by cset. Restrict the workqueue to use only cpu 0.
		echo "$HOST_CORES_MASK" > /sys/bus/workqueue/devices/writeback/cpumask
		# THP can allegedly result in jitter. Better keep it off.
		echo never > /sys/kernel/mm/transparent_hugepage/enabled
		# Force P-states to P0
		echo performance | tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
		echo 0 > /sys/bus/workqueue/devices/writeback/numa
		>&2 echo "VMs Shielded"
		echo "Finished cpu isolation for domain \"${VM_NAME}\""
	elif [ "$VM_ACTION" = "release" ]
	then
		echo "Started cpu un-isolation for domain \"${VM_NAME}\""
		# All VMs offline
		sysctl vm.stat_interval=1
		sysctl -w kernel.watchdog=1
		unshield_vm
		echo always > /sys/kernel/mm/transparent_hugepage/enabled
		echo powersave | tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
		echo 1 > /sys/bus/workqueue/devices/writeback/numa
		>&2 echo "VMs UnShielded"
		echo "Finished cpu un-isolation for domain \"${VM_NAME}\""
	else
		echo "Invalid VM action" 2>&1
	fi

}

main() {

	if readlink /sbin/init | grep -q systemd
	then
		systemd_method
	else
		cset_method
	fi

}

main

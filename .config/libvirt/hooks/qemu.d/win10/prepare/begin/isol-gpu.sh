#!/bin/sh

# Helpful to read output when debugging
set -x

# load variables in conf file
. "/etc/libvirt/hooks/kvm.conf"

VM_NAME="$1"
VM_ACTION="$2"

start() {

	echo "Starting hooks for starting domain \"${VM_NAME}\""

	# Stop display manager
	if readlink /sbin/init | grep -q systemd
	then
		systemctl stop "$DM_SERVICE"
	elif readlink /sbin/init | grep -q openrc
	then
		rc-service "$DM_SERVICE" stop
		rc-service nvidia-persistenced stop
	fi

	# Unbind VTconsoles
	echo 0 > /sys/class/vtconsole/vtcon0/bind
	echo 0 > /sys/class/vtconsole/vtcon1/bind

	# Unbind EFI-Framebuffer
	echo efi-framebuffer.0 > /sys/bus/platform/drivers/efi-framebuffer/unbind

	# Avoid a Race condition by waiting 5 seconds. This can be calibrated to be shorter or longer if required for your system
	sleep 5 

	# Unload Nvidia drivers
	modprobe -r nvidia_drm
	modprobe -r nvidia_modeset
	modprobe -r drm_kms_helper
	modprobe -r	nvidia_uvm
	modprobe -r	nvidia
	modprobe -r	drm
	modprobe -r i2c_dev

	# Unbind the GPU from display driver
	virsh nodedev-detach "$VIRSH_GPU_VIDEO"
	virsh nodedev-detach "$VIRSH_GPU_AUDIO"

	# Load VFIO Kernel Module
	modprobe vfio
	modprobe vfio_pci
	modprobe vfio_iommu_type1

	echo "Finished hooks for starting domain \"${VM_NAME}\""

}

revert() {

	echo "Starting hooks for stopping domain \"${VM_NAME}\""

	# Unload vfio driver
	modprobe -r vfio_pci
	modprobe -r vfio_iommu_type1
	modprobe -r vfio

	# Re-Bind GPU to Nvidia Driver
	virsh nodedev-reattach "$VIRSH_GPU_AUDIO"
	virsh nodedev-reattach "$VIRSH_GPU_VIDEO"

	# Rebind VT consoles
	echo 1 > /sys/class/vtconsole/vtcon0/bind
	# Some machines might have more than 1 virtual console. Add a line for each corresponding VTConsole
	echo 0 > /sys/class/vtconsole/vtcon1/bind

	# Read nvidia gpu info
	nvidia-xconfig --query-gpu-info > /dev/null 2>&1

	# Bind EFI framebuffer
	echo "efi-framebuffer.0" > /sys/bus/platform/drivers/efi-framebuffer/bind

	# Reload nvidia modules
	modprobe nvidia_drm
	modprobe nvidia_modeset
	modprobe drm_kms_helper
	modprobe nvidia
	modprobe drm
	modprobe i2c_dev

	# Restart Display Manager
	if readlink /sbin/init | grep -q systemd
	then
		systemctl start "$DM_SERVICE"
	elif readlink /sbin/init | grep -q openrc
	then
		rc-service "$DM_SERVICE" start
		rc-service nvidia-persistenced start
	fi

	echo "Finished hooks for stopping domain \"${VM_NAME}\""

}

main() {

	# TODO: make this *not* Xorg dependent
	if ! grep "LoadModule" "/var/log/Xorg.0.log" | grep -q nvidia
	then
		echo "Nvidia module was not loaded by Xorg, therefore gpu doesn't need to be unbound & rebound"
		echo "Exiting ..."
		exit 0
	fi

	if [ "$VM_ACTION" = "prepare" ]
	then
		start
	elif [ "$VM_ACTION" = "release" ]
	then
		revert
	else
		echo "Invalid VM action" 2>&1
	fi

}

main

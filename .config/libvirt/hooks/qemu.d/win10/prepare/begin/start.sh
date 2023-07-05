#!/bin/bash
# Helpful to read output when debugging
set -x

# load variables in conf file
source "/etc/libvirt/hooks/kvm.conf"

# Stop display manager
if ls -l /sbin/init | grep -q systemd
then
    systemctl stop "$DM_SERVICE"
elif ls -l /sbin/init | grep -q openrc
then
    rc-service "$DM_SERVICE" stop
fi

# Unbind VTconsoles
echo 0 > /sys/class/vtconsole/vtcon0/bind
echo 0 > /sys/class/vtconsole/vtcon1/bind

# Unbind EFI-Framebuffer
echo efi-framebuffer.0 > /sys/bus/platform/drivers/efi-framebuffer/unbind

# Avoid a Race condition by waiting 2 seconds. This can be calibrated to be shorter or longer if required for your system
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


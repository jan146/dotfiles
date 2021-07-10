#!/bin/bash
set -x

# Load kvm.conf
source "/etc/libvirt/hooks/kvm.conf"

# Unload vfio driver
modprobe -r vfio_pci
modprobe -r vfio_iommu_type1
modprobe -r vfio

# Re-Bind GPU to Nvidia Driver
virsh nodedev-reattach $VIRSH_GPU_AUDIO
virsh nodedev-reattach $VIRSH_GPU_VIDEO

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
systemctl start lightdm.service


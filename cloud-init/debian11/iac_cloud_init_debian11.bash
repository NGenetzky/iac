#!/bin/bash

iac_virt_install(){
  virt-install \
    --name $VM_NAME \
    --memory 1024 \
    --disk /var/lib/libvirt/images/$VM_NAME/root-disk.qcow2,device=disk,bus=virtio \
    --disk /var/lib/libvirt/images/$VM_NAME/cloud-init.iso,device=cdrom \
    --os-type linux \
    --os-variant debian10 \
    --virt-type kvm \
    --graphics none \
    --network network=default,model=virtio \
    --import
}

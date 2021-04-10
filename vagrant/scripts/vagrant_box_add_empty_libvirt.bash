#!/bin/bash
# Reference:
# https://github.com/rgl/pxe-vagrant/blob/master/create_empty_box.sh

# create and add an empty box to the libvirt provider.
VAGRANT_EMPTYDIR="$HOME/.vagrant.d/boxes/empty/0/libvirt"
if [ ! -d "${VAGRANT_EMPTYDIR}" ]; then
	mkdir -p "${VAGRANT_EMPTYDIR}"
	cd "${VAGRANT_EMPTYDIR}" || exit 1
	cat <<- EOF > Vagrantfile
	Vagrant.configure(2) do |config|
	  config.vm.provider 'libvirt' do |lv|
	    lv.graphics_type = 'spice'
	    lv.video_type = 'qxl'
	    lv.channel :type => 'unix', :target_name => 'org.qemu.guest_agent.0', :target_type => 'virtio'
	    lv.channel :type => 'spicevmc', :target_name => 'com.redhat.spice.0', :target_type => 'virtio'
	  end
	end
	EOF
	echo '{"format":"qcow2","provider":"libvirt","virtual_size":10}' >metadata.json
	qemu-img create -f qcow2 box.img 10G
	# tar cvzf empty.box metadata.json Vagrantfile box.img
	# vagrant box add --force empty empty.box
fi

#!/bin/bash -e
set -x

# Get cloud-init
sudo apt update
sudo debconf-set-selections -v <<<"cloud-init cloud-init/datasources multiselect NoCloud, None" 2>/dev/null
sudo apt install -y cloud-init
#sudo debconf-set-selections -v <<<"cloud-init cloud-init/datasources multiselect NoCloud, None" 2>/dev/null; sudo dpkg-reconfigure cloud-init -f noninteractive 2>/dev/null;

# Prepare datasource
sudo tee /etc/cloud/cloud.cfg <<'YAML'
# The top level settings are used as module
# and system configuration.
datasource:
  NoCloud:
    seedfrom: /boot/

# A set of users which may be applied and/or used by various modules
# when a 'default' entry is found it will reference the 'default_user'
# from the distro configuration specified below
users:
   - default

# If this is set, 'root' will not be able to ssh in and they
# will get a message to login instead as the above $user (debian)
disable_root: true

# This will cause the set+update hostname module to not operate (if true)
preserve_hostname: false

# Example datasource config
# datasource:
#    Ec2:
#      metadata_urls: [ 'blah.com' ]
#      timeout: 5 # (defaults to 50 seconds)
#      max_wait: 10 # (defaults to 120 seconds)

# The modules that run in the 'init' stage
cloud_init_modules:
 - migrator
 - bootcmd
 - write-files
 - mounts
 - rsyslog
 - users-groups
 #- ssh

# The modules that run in the 'config' stage
cloud_config_modules:
# Emit the cloud config ready event
# this can be used by upstart jobs for 'start on cloud-config'.
 - ssh-import-id
 - locale
 - set-passwords
 - ntp
 - timezone
 - runcmd

# The modules that run in the 'final' stage
cloud_final_modules:
 - package-update-upgrade-install
 - scripts-vendor
 - scripts-per-once
 - scripts-per-boot
 - scripts-per-instance
 - scripts-user
 - phone-home
 - final-message

# System and/or distro specific settings
# (not accessible to handlers/transforms)
system_info:
   # This will affect which distro class gets used
   distro: debian
   # Default user name + that default users groups (if added/used)
   default_user:
     name: pi
     #lock_passwd: True
   # Other config here will be given to the distro class and/or path classes
   paths:
      cloud_dir: /var/lib/cloud/
      templates_dir: /etc/cloud/templates/
YAML

# Create meta-data
sudo tee /boot/meta-data <<'YAML'
instance-id: iid-raspberrypi-nocloud
YAML

# Create user-data
sudo tee /boot/user-data <<'YAML'
#cloud-config
packages:
 - vim
 - python3-pip
ssh_authorized_keys:
 - ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC5UXba62TkiA6VqlBPxXdronnGDDdZ5Tcv0+wLLbb5k7A4Mn/XBZom/mKxbYhKVLDLHPYjpYub2piHOq//hP0qqqYJWMMvmRMGvyU9SAH7p+TLTLflfv8Th2jXAM+WOFESmWAY0uut2O0D7cCN5ILXcPNoGKqWI2Fyyx237pMHYOHYB82rAqdjbBZCJMd/Gd+fD0rogoCX3KZdDStzzl8u4C5aSB3rD7WvGNaqwDoQr+DakKnFXrgJG/rQSDcYuvMmi99bjyYm93riSNJ3QxnFz4eFQSpG28al54IkU1E9/aYfJLImCFfeMVNmbbHxtq9CpWR/HEoK3J4yExglyqCORTciDuydgqgHyVuqREBuxjGS4pldpcvuacqF2El2p6Saias1uv3JuoVLnLCCva4Us+m8p4Z2AQNm0I0Bl1OgJLLQUoe1dFomREBocnuwMByHoYCDYTjxw5DqehuTpSO7RtBVCa6492JnmKmwy1K9jPqsWrdCfEA9DVcnNSYsvqJmfcTHOJJ0pkC/f6QgfuAD3tWVSIZqYKnqkpCtixOS14+uCVe24Q4n8rBZF/8xNXThcbs9kWVi7k3aLgnLOLIosKZkHl1R3n+ss6TBH8D/Z19vuWJpiUNc1GbOpqsRPPFKwEtCUpZbj/D77zgMaRx3YX8w/dLcDZXUwDlwFdK1AQ==
 - ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDTcJk15RmarEQiZ7im3F6i5o0OOvPKCOmKKFwpGPJ3MZmYEXW3FRlsdGwRomNWdH6dTiDROQ9Cut0CMbeRrPvp6Y4H2iTXEnKShLYj5h7H00KLZGRcalC/BlpvNIBgasvaHq1Lu1oLJGQg62RErCWk2cdevQkJMAB9QObxukVp1uVBRWxGVlrVk2JbqZZ7zh8Lf81f6k9Lw9F3d03vHKARLIfXZVFpEY+qnTp0oXAJ1xTjrqY5reKNswiLtjyJwR6y16sOFQ4AE7rZI/q4zIcKgeBj/DHx2kqJxB/FSpnPRE0kDaAdbhljC7G8ulXptbd/OAtDLUIhYwvRr+AQKeZt bbronosky@Bruno.local

YAML

# Initialize cloud-init
sudo cloud-init init --local

# Create a script to run per boot
sudo tee /var/lib/cloud/scripts/per-boot/00_run-parts.sh <<'BASH'
#!/bin/bash

# Prevent *.sh from returning itself if there are no matches
shopt -s nullglob

# Run every per-once script
run-parts --regex '.*\.sh$' /boot/per-once

# Rename every per-once script
for f in /boot/per-once/*.sh; do
    mv $f $(dirname $f)/$(basename $f .sh).$(date +%F@%H.%M.%S)
done

# Run every per-boot script
run-parts --regex '.*\.sh$' /boot/per-boot
BASH
sudo chmod +x /var/lib/cloud/scripts/per-boot/00_run-parts.sh

# Create sample per-boot and per-once scripts
sudo mkdir -p /boot/{per-boot,per-once}
sudo tee /boot/per-boot/01_get_ready.sh \
         /boot/per-boot/02_do_it.sh \
         /boot/per-once/01_prepare.sh \
         /boot/per-once/02_install_stuff.sh <<'BASH'
#!/bin/bash

date="$(date +"%x %X")"
script_path="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
script_name="$(basename ${BASH_SOURCE[0]} .sh)"
log_name="$(basename $script_path)"

echo "$date - $script_name" >> /home/pi/${log_name}.out
BASH

echo "Cloud-Init setup is complete."
# vim: et sw=4 ts=4 sts=4 syntax=sh

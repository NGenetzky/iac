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
  - ecdsa-sha2-nistp521 AAAAE2VjZHNhLXNoYTItbmlzdHA1MjEAAAAIbmlzdHA1MjEAAACFBACaun+Mwa1SJOiBJ3m8Ms3GGca1570LpxqWYG1O93VEGGHAIy3eW79wPGGHFEBaGm/7/4/awJAYh/1MdXXhpACljwByXp3YO1xI8BFPM0PX1uNsVfdQCf4WC2kQuZ3sdpOn6k3QT96ceGAWg2U+TmkMC5QqKBiQpLffgMtbsNoGOmdrAw== ngenetzky@github/68414559 # ssh-import-id gh:ngenetzky
  - ecdsa-sha2-nistp521 AAAAE2VjZHNhLXNoYTItbmlzdHA1MjEAAAAIbmlzdHA1MjEAAACFBADhNa4uAZ+0f8Du7Ey9R6A+SW8YYUEvZjR8CyK7cqdYgz0VKlXkscnyDQBKoUYlqp0warknceXGbkxbhSqbvaVEVwF6Bxt47jfj4IO0FZqyBKNSwqVgKtbZPzT9nZMGFrDzVN+UP5/OyfWpvAS1ekxelx5A05+L7FG5/BOOSmncxQxigw== ngenetzky@github/59650339 # ssh-import-id gh:ngenetzky
  - ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIERf/7qtE91GhaDz+wkMV0v5URygoNF4mDRr3ugAyWkY ngenetzky@github/54062786 # ssh-import-id gh:ngenetzky
  - ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIElO3ffWOuhA2bHoO0Lj8lqVbDP7KMeJxajulFtv72Yq ngenetzky@github/39916617 # ssh-import-id gh:ngenetzky
  - ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFs/U9+LwU/B6DEKPnmuacznsxIXGbvB7HsSqVrdivZR ngenetzky@github/48466172 # ssh-import-id gh:ngenetzky
  - ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQChLJqSh0OU3dYK3xGR+N9Sk1N6cusknGVViwDn5rn0EFJmdBndsNu3zgRUdZ6z84C70w6VYbkjhj+l5t08Kd2PCswFIg3wyEnKOXCA7gFpKtvC3O3vXaw9N6DbWHOaABGQ7C1v2SHekFue/MyYDhV+G6NFpXFj1H0HTTsaNNSG5xLqQxylPcjvvggm358o0xHmX0M3vcrl9LBLZu55HYrXZ32kOwxHB+STFSLtB4yi0HxmmxpddpttYi/+W7HIzRwy7Hs40oqerl++Y8qd8MaVITYKSnCQ0qwkjt2+xSI0yxtMZDgONhjQ/806q8ITFUSZxSy3YvzO50u/PiyqgSzN ngenetzky@github/48185353 # ssh-import-id gh:ngenetzky
  - ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDcVYQT0ptIoEBAvxodaPis8oTr8IYvVWr3EvMXluylRwqF41g6QCTKRfF7O3mfPjB4q2dUkj8wGmw2YswwvgP+60NWc2jpqlu5YvHI+wL+3knBZXCL6k7Isl+hRb8eRnjH1RLo2QocNdAV4/1JnIY3liPOFNOBB/If7omKhVJYNQeyq6OyzRn3cloFnaRAf5JZ6Xn9nYOpp0k1xLtexei5itef/gO/98eKSN4Px965KI9rFo9y2AP/aPKlCRh1Sdd/0GfL3aAln+JxAGKm7/wVDI9q1xfqQcBywH1UvxptR0xVzjzyN6lS6X0mrGEeUTrUs7uhch0N+QH+S5ShlxiP ngenetzky@github/31860057 # ssh-import-id gh:ngenetzky
  - ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDK0EYRpukfVuhj0m10EOKeKqHIo+7xynwTHAEagi1G3/4CV2xTUlMJ07GJvw4ZDHsGDQ7y4j2Nc6XYrnPDsDYEeFjG1R+X0rmycwdT1rAgSd3g+kL0KFcVvP5klDsr5Qxf4URU+Y2yyfyehPxNcjBuqr1sMjY30/VY4CjRGHYdDqnrt71dulKJH5vxn+EA/0ZiuN70C3gcsfEVMt35LCClBUdYy/TR4QrPtPRtcIhFjhob3hjAU/s2FygTRGNS7FF8ZQhD20rtH9k9UmpSi7yX0ubVNBDPnb61cYXjQTKDw8QXss0Fajl3Z+6SXGYLRIdtTxwDT/EKqwptI3cannHeO64pGTIvrJKe6HSoTCAOR3bD//HWc1+pxyPf2Rc4wvSBcz4sM982uPn5UhjeMZF4O0n/HCotctCdP+PslMWJDa1ywKVB/+8Wsrq9sYuBPM/4XXUQh/iLlEYyA5H/le4fQ2GcAFhVrp3taFz2mEZeXdu/AOT8gbK/iA30JPStup0= ngenetzky@github/62643224 # ssh-import-id gh:ngenetzky
  - ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC/iOFYf2KFyLHw30uqpd4FhoBM+c+zlhw7OpYRxY6Ih2B42rKYDOWpqH1+PuDvvYRiE47LRrBBTjOGo8LcV+cdiHDAAXKfOSIUy2MW3WLLcIv12z763DKET7LheOEHKG2dLo7BSAgDopngNLjnnXPqzCM5f8XKkJwRrOnsqw+O10/Oh5/crsjeHrHbUtnQpHSqEhiLtysg/llaBeyRgNBSHrDe6sRQNUe9zOPQ/sGoSV6yoxM8P2l5bT7Wbo78KanrVl7+U+77y9YRtrNDXBzrR7yREDVfQ771kk/gE5RhBpO8ZPgKJJx5/09ZD63w77eY1b2wFfja8EG2rMPxhDXKFGeO8tn3TFxrYwdacb7bG+p1e30Fa2/U6vKO2pByoLtMDnf3IWX+ft1CJZDmFgSB/jbS5Wqi1EYabz/DHt9Dh2rgPoVaM5YQVnyY+5P82RBJylTJQnezxxqm/sdys6dXqGihUbjPBrrLL5CH5Pl2s5sf5v+Qr+NnwNZcHj6WsnDSAnIBp5fknxauWqCK3sqMo6Ux5oB1/79SCLmR/FMZ9BfejycW7vSz69rn/WmpljWW8nCw4DmqKtg06EY9vZc/mQT+VjTNPaL5VAxydEUnW+Bx20sfDth4xEcLLpI9yTVnd9/tneMikbnTbPBYrdytKHFjzKegFYUOYvgihpdPfQ== ngenetzky@github/60116622 # ssh-import-id gh:ngenetzky
  - ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDevDlTTfIOpvmsEowyEfZn0uLglGe0HC5JE2Z9fMOs7Bkcjr2QlMnwgWKIrVVray4V8r1vMdavU2uqO3yhoI6nqypc9dm/4hcgsfmY/RSwCNngAs5BkK4Dn37vcbaXYvYwJ4z2E0akNL6FEipck5MVRRRQIo6bDpEQRGrUjB2Kxo2fxNPM8vOOmHKUBl8t2hljBjujrbWLnzo05VrkXJ2hhk2UbOPWwfpsBD8+30vi5tfmCiabijKT1WHYzzKUPBWdmNKnjHmKFyGUmg0ZFswh8pIPFAabaRCXkGvTd4TTbA0NV3NGRXoZ8bvVYE3220ZeBHhJoe13GMTLyd+rYiKEgPHUu+kmqCAlhM/SlPzbmZBmUAhGhXQ9HEoeuF3z/K+kXS0al/TlIlq48/NE5zQYdnCFK1puJGtUiCTb2zgK53FWa5GhZf/fVWiabw4QuObaXoqOgH9zzNBcTLxSN9hx10CERsb7ZaJEfHsc7bwNmV5udWcWeOAgnnG3M5V0MzMq3P1LSoOW6xYzqnWKKzKCzt0cZyTvAlaPPO43wh8k6OpHrGKVwPlMcCLsO7DLY8pTy8FuGxPcqLr4dMe8J8j4sGzJFstes3XJm0m/pqTadrIc1oKHSBTS6U9/TtoArQA4i8mOxoeK2hLpxwRPYUyz1PUu4XdJvpoAxt/RnfdhdQ== ngenetzky@github/60364363 # ssh-import-id gh:ngenetzky
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

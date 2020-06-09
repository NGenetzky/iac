#!/usr/bin/bash
# If you want to test changes without restarting the box, follow these steps:
# 1. Edit the meta-data and user-data files located on the box in
# /var/lib/cloud/seed/nocloud-net/.
# 2. Remove particular files that identify the current cloud-init instance
# configuration (which stop cloud-init from re-running).
# 3. Force cloud-init to run again.

# Remove particular files that identify the current cloud-init instance
rm -rf \
    /var/lib/cloud/instance \
    /var/lib/cloud/instances/* \
    /var/lib/cloud/sem/*

# Force cloud-init to run again.
sudo cloud-init init
sudo cloud-init modules


#!/bin/bash
# Reusable audit script for NGenetzky's Linux hosts

echo "--- Starting Audit for $(hostname) [$(date)] ---"

# 1. Check for Broken Symlinks (specifically for pipx/binaries)
# Pipx usually installs to ~/.local/bin. Broken symlinks occur after Python upgrades.
echo "[*] Checking for broken symlinks in ~/.local/bin..."
find "$HOME/.local/bin" -xtype l -print | while read -r link; do
    echo "  [BROKEN]: $link -> $(readlink "$link")"
    # Optional: Re-install logic could go here if you detect a pipx pattern
done

# 2. Check for Failures in Systemd Units
echo "[*] Checking for failed system services..."
failed_services=$(systemctl --failed --quiet | grep "loaded units listed")
if [ -n "$failed_services" ]; then
    systemctl --failed --no-legend
else
    echo "  No failed services found."
fi

# 3. Disk Space Check (Curation Mindset)
# Alert if any primary partition is > 90%
echo "[*] Checking disk usage..."
df -h | awk '$5+0 > 90 {print "  [WARNING]: " $1 " is at " $5}'

# 4. Tailscale Connectivity
# Useful for nodes like 'ross' or 'river' that act as subnet routers
if command -v tailscale >/dev/null 2>&1; then
    echo "[*] Tailscale Status..."
    tailscale status | head -n 5
fi

echo "--- Audit Complete ---"

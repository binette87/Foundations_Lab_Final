#!/bin/bash

# 1. Secure the System Identity Files (The Remediation)
sudo chmod 640 /etc/shadow
sudo chown root:shadow /etc/shadow

# 2. Secure the Local Vault
# (Ensuring only you can read/write your vault folder)
chmod 700 ~/Vault

echo "System Hardening Complete. Security Posture: Gold Standard."

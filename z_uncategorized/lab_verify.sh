#!/bin/bash
echo "Starting System Audit..." > setup_verify.txt
echo "User: $user" >> setup_verify.txt
ip addr show >> setup_verify.txt

#!/bin/bash

set -o errexit
set -o pipefail
set -o nounset

sudo apt update
sudo apt install -y linux-tools-common linux-tools-`uname -r` htop

# Install plot packages
sudo apt -y install python3-pip
pip install matplotlib


# Set scaling governor to performance
sudo cpupower frequency-set --governor performance

# Disable turbo
echo "1" | sudo tee /sys/devices/system/cpu/intel_pstate/no_turbo

# Turn off SMP
echo off | sudo tee /sys/devices/system/cpu/smt/control

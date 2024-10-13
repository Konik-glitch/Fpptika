#!/bin/bash

# Installations (using proxies set in the environment)
echo "Installing tools..."
pacman -Sy --noconfirm git wget python-pip ruby

# Create a tools folder in ~/
mkdir -p /home/whoami/tools
cd /home/whoami/tools || { echo "Failure in cd command"; exit 1; }

# Example installation
echo "Installing wpscan"
git clone https://github.com/wpscanteam/wpscan.git
cd wpscan || { echo "Failure in cd command"; exit 1; }
gem install bundler && bundle install --without test
cd /home/whoami/tools/ || { echo "Failure in cd command"; exit 1; }
echo "Done installing tools"
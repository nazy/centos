#!/bin/bash

set -x
set -e

# Disable fastestmirror plug-in
if [ -e /etc/yum/pluginconf.d/fastestmirror.conf ]; then
  sed -i "s/enabled=1/enabled=0/" /etc/yum/pluginconf.d/fastestmirror.conf
fi

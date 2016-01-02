#!/bin/bash

# Disable all yum repositories

set -x
set -e

if ls /etc/yum.repos.d/*.repo > /dev/null 2>&1; then
  for repo in /etc/yum.repos.d/*.repo; do
    if [ -e "${repo}" ]; then
      mv -f "${repo}" "${repo}.disabled"
    fi
  done
fi

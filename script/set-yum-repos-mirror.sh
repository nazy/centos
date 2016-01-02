#!/bin/bash -ex

if [ -z "${MIRROR_BASE_URL}" ]; then
  echo "MIRROR_BASE_URL is not specified."
  exit 0
fi

# Remove trailing "/"
MIRROR_BASE_URL=${MIRROR_BASE_URL%/}
# Escape "/" for sed
MIRROR_BASE_URL=${MIRROR_BASE_URL//\//\\/}

for repo in /etc/yum.repos.d/*.repo; do
  if [ ! -e "${repo}.org" ]; then
    cp ${repo} ${repo}.org
  fi
  # Replace base url with MIRROR_BASE_URL, and also enable baseurl.
  sed -i "s/#baseurl=http:\/\/mirror.centos.org\/centos\//baseurl=${MIRROR_BASE_URL}\//" ${repo}
  # Disable mirrorlist
  sed -i "s/mirrorlist/#mirrorlist/" ${repo}
done

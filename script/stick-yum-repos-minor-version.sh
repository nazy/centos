#!/bin/bash -eux

# Get version information from /etc/redhat-release.
if [ -e /etc/redhat-release ]; then
  for count in {1..10}; do
    word=`cut -f ${count} -d' ' /etc/redhat-release`;
    case "${word}" in
      release)
        VERSION=`cut -f $((count + 1)) -d' ' /etc/redhat-release`;
        ;;
      Red)
        DISTRIBUTION=RHEL
        ;;
      CentOS)
        DISTRIBUTION=CentOS
        ;;
    esac
    if [ -z "${word}" ]; then
      break
    fi
  done
else
  echo 'Non RHEL and its clone.' 1>&2
  exit 1
fi
MAJOR=`echo ${VERSION} | cut -d. -f 1`

# Specify $releasever replacement string which includes minor version.
case "${MAJOR}" in
  7|6)
    if [ ! -e /etc/yum/vars ]; then
      mkdir /etc/yum/vars
    fi
    echo ${VERSION} > /etc/yum/vars/releasever
    ;;
  5)
    for repo in /etc/yum.repos.d/*.repo; do
      sed -i "s/\$releasever/${VERSION}/" $repo
    done
    ;;
  *)
    echo "Unsupported version ${VERSION}" 1>&2
    exit 1
    ;;
esac

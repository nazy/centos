#!/bin/bash -ex

# Extract repodata, Packages(CentOS 6, 7) and CentOS(CentOS 5) files
if ls /tmp/iso/*.iso > /dev/null 2>&1; then
  for iso in /tmp/iso/*.iso; do
    mount ${iso} /mnt -o loop
    for dir in repodata Packages CentOS; do
      if [ -e /mnt/${dir} ]; then
        mkdir -p /media/CentOS/${dir}
        cp -rpv /mnt/${dir}/* /media/CentOS/${dir}/
      fi
    done
    umount /mnt
    rm -f ${iso}
  done
  rm -rf /tmp/iso
fi

# Enable CentOS-Media.repo
if [ -e /etc/yum.repos.d/CentOS-Media.repo.disabled ]; then
  mv -f /etc/yum.repos.d/CentOS-Media.repo.disabled /etc/yum.repos.d/CentOS-Media.repo
fi

if [ -e /etc/yum.repos.d/CentOS-Media.repo ]; then
  # CentOS 5, 6
  sed -i "s/enabled=0/enabled=1/" /etc/yum.repos.d/CentOS-Media.repo
else
  # CentOS 7
  cat > /etc/yum.repos.d/CentOS-Media.repo <<HERE
# CentOS-Media.repo
#
#  This repo can be used with mounted DVD media, verify the mount point for
#  CentOS-7.  You can use this repo and yum to install items directly off the
#  DVD ISO that we release.
#
# To use this repo, put in your DVD and use it with the other repos too:
#  yum --enablerepo=c7-media [command]
#
# or for ONLY the media repo, do this:
#
#  yum --disablerepo=\* --enablerepo=c7-media [command]

[c7-media]
name=CentOS-\$releasever - Meida
baseurl=file:///media/CentOS/
        file:///media/cdrom/
        file:///media/cdrecorder/
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7
enabled=1

HERE
fi

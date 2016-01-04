#!/bin/bash -eux

usage() {
  echo "Usage: ${0} [-dvaih]" 1>&2
  echo "Print OS distribution and version." 1>&2
  echo 1>&2
  echo "Options:" 1>&2
  echo "  -d Show distribution" 1>&2
  echo "  -v Show version" 1>&2
  echo "  -a Show major verison" 1>&2
  echo "  -i Show minor verison" 1>&2
  echo "  -h Show this message" 1>&2
}

if [ -e /etc/redhat-release ]; then
  for count in {1..10}; do
    word=`cut -f ${count} -d' ' /etc/redhat-release`;
    case "${word}" in
      release)
        version=`cut -f $((count + 1)) -d' ' /etc/redhat-release`;
        ;;
      Red)
        distribution=RHEL
        ;;
      CentOS)
        distribution=CentOS
        ;;
    esac
    if [ -z "${word}" ]; then
      break
    fi
  done
else
  echo 'Non RHEL and its clone.' 1>&2
  exit -1
fi

MODE=version
while getopts dvaih OPT; do
  case "${OPT}" in
    d)
      MODE=distribution
      ;;
    v)
      MODE=version
      ;;
    a)
      MODE=major
      ;;
    i)
      MODE=minor
      ;;
    h)
      usage
      exit 0
      ;;
    *)
      usage
      exit 1
  esac
done

case "${MODE}" in
  distribution)
    echo ${distribution}
    ;;
  version)
    echo ${version}
    ;;
  major)
    echo ${version} | cut -d. -f 1
    ;;
  minor)
    echo ${version} | cut -d. -f 2
    ;;
esac

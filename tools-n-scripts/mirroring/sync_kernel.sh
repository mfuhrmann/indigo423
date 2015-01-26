#!/bin/bash
# Synchronize Linux Kernel sources
#
# If you want bash debug
# set -x

SCRIPT_PATH=$(dirname $(readlink -f $0))
UTILS_SCRIPT="${SCRIPT_PATH}/../include/utils.sh"

if [ ! -f ${UTILS_SCRIPT} ]; then
    echo "Utils script in ${UTILS_SCRIPT} required"
    exit 1
fi

. ${UTILS_SCRIPT} "${0}"

RSYNC_CMD=/usr/bin/rsync
BW_LIMIT=0
# RSYNC_PROT=rsync
RSYNC_HOST=ftp4.de.FreeBSD.org
SRC=kernel.org
DST=/storage/vol2/mirror/kernel.org
RSYNC_OPT="-vazH --delete --group=mirror --owner=mirror"
RSYNC_LOG=/var/www/mirror/pub/log/kernel.log
DATE=`date +"%Y-%m-%d %r"`

START_TIME=$(date '+%s')
${RSYNC_CMD} ${RSYNC_OPT} --bwlimit=${BW_LIMIT} ${RSYNC_HOST}::${SRC}/ ${DST}
RETURN_CODE=$?
echo "Return code: ${RETURN_CODE} - Last sync: ${DATE}" > ${RSYNC_LOG}
END_TIME=$(date '+%s')
TIME=$(timer START_TIME END_TIME)
checkExit ${RETURN_CODE} "Rsync return code ${RETURN_CODE} [${TIME}]."
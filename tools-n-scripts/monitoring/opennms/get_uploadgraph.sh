#!/bin/bash
#
# Script to get a graph from OpenNMS and save it in the file system
 
NOW=$(( $(date +%s) * 1000 ))
ONMS_SERVER=localhost

PORT=8980
NODE_ID=1
REPORT=mib2.bitsTraffic
NET_DEVICE=venet0

DAY_WINDOW=1
INTERVAL=$(( $(echo ${DAY_WINDOW}) * 24 * 60 * 60 * 1000))
START=$(( $(echo ${NOW}) - $(echo ${INTERVAL}) ))

DST_PATH=/var/www
OUTPUT=${DST_PATH}/bandwith-upload.png

SEND_EVT=/usr/bin/send-event.pl
PASSIVE_EVT=uei.opennms.org/services/passiveServiceStatus
PASSIVE_NODE=vps-1010379-3404.united-hoster.de
PASSIVE_IP=127.0.0.1
PASSIVE_SVC=Bandwith-PNG-Export


wget "http://${ONMS_SERVER}:${PORT}/opennms/graph/graph.png?resourceId=node%5b${NODE_ID}%5d.interfaceSnmp%5b${NET_DEVICE}%5d&report=${REPORT}&start=${START}&end=${NOW}" -O ${OUTPUT}

if [ $? -eq 0 ]; then
  ${SEND_EVT} ${PASSIVE_EVT} --parm "passiveNodeLabel ${PASSIVE_NODE}" \
                             --parm "passiveIpAddr ${PASSIVE_IP}" \
                             --parm "passiveServiceName ${PASSIVE_SVC}" \
                             --parm "passiveStatus Up"
else
  ${SEND_EVT} ${PASSIVE_EVT} --parm "passiveNodeLabel ${PASSIVE_NODE}" \
                             --parm "passiveIpAddr ${PASSIVE_IP}" \
                             --parm "passiveServiceName ${PASSIVE_SVC}" \
                             --parm "passiveStatus Down"
fi


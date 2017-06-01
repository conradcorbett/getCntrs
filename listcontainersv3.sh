#!/bin/bash
#source graphic.sh

#content-type
CT="Content-Type:application/json"

#user and password credentials
USER="admin"
PASSWD="nutanix/4u"

#services
SERVICE_URL="https://10.21.232.57:9440/PrismGateway/services/rest/v2.0"
RESPONSE_CODE="%{http_code}\n"

#resource
RESOURCE_SC="/storage_containers/"

#response code
STATUS=$(curl --write-out $RESPONSE_CODE --insecure -s --output /dev/null -H $CT -X GET -u $USER:$PASSWD "$SERVICE_URL$RESOURCE_SC")
echo "Response Code: " $STATUS
echo

CTRSGETJSON=$(curl --insecure -s -H $CT -X GET -u $USER:$PASSWD "$SERVICE_URL$RESOURCE_SC")

CTRS=$(echo $CTRSGETJSON | jq -r .entities[].name)

#print output on different line
#echo "The storage containers on this cluster are:"
#printf '%s\n' "${CTRS[@]}"
#echo

#print output on different line
for i in ${CTRS[@]}
do echo $i
done
echo

echo "Type a Container: "
read CTR
clear

CTRGETJSON=$(curl --insecure -s -H $CT -X GET -u $USER:$PASSWD "$SERVICE_URL$RESOURCE_SC"?search_string=$CTR)
ECX=$(echo $CTRGETJSON | jq -r .entities[].erasure_code)
echo "Erasure Coding is $ECX for $CTR"
COMP=$(echo $CTRGETJSON | jq -r .entities[].compression_enabled)
echo "Compression is $COMP for $CTR" 

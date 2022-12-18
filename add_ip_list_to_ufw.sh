#!/bin/bash

#####
## Add IPs from list to deny with UFW.
#####

HOST_IPV4=$(hostname -I)

UFW_SETTINGS_PATH="/root/ufw"

#DENY_IP_RANGES_NAME="deny_ip_ranges.txt"
#DENY_IP_RANGES="${UFW_SETTINGS_PATH}/${DENY_IP_RANGES_NAME}"
#HUN_IP_RANGES_NAME="hungary_ip_ranges.txt"
#HUN_IP_RANGES="${UFW_SETTINGS_PATH}/${HUN_IP_RANGES_NAME}"
FIXNET_IPS_NAME="fixnet_ips.txt"
FIXNET_IPS="${UFW_SETTINGS_PATH}/${FIXNET_IPS_NAME}"

UFW_DENY_IP_LIST_NAME="ufw_deny_ip_list.txt"
UFW_DENY_IP_LIST="${UFW_SETTINGS_PATH}/${UFW_DENY_IP_LIST_NAME}"

## TODO: from parameter, like --port=<number>
UFW_DENY_PORT=22

## TODO: from parameter, like --occurance=<number>
MIN_OCCURANCE=10

## TODO: from parameter, like --iplist=<path>
IP_LIST_TO_DENY="${UFW_DENY_IP_LIST}"
echo "Selected file: ${IP_LIST_TO_DENY}"

## TODO: refresh online
TMP_FIXNET_IPS_RESULT_FILE="${FIXNET_IPS}.tmp"
cat "${FIXNET_IPS}" | grep -E "^[[:blank:]]*[^[:blank:]#;]" | grep -E -o "([0-9]{1,3}[\.]){3}[0-9]{1,3}" > "${TMP_FIXNET_IPS_RESULT_FILE}"
readarray -t FIXNET_IPS_ARRAY < "${TMP_FIXNET_IPS_RESULT_FILE}"
rm -f "${TMP_FIXNET_IPS_RESULT_FILE}"
echo "Collect fixnet/fixvps IPs: ${#FIXNET_IPS_ARRAY[@]}"

echo "Add UFW rules..."
while IFS=" " read -r IP_COUNT DENY_IP || [ -n "$DENY_IP" ] || [ -n "$IP_COUNT" ]
do
    ## Skip, if IP occurance isn't too much
    if [[ "${IP_COUNT}" -lt "${MIN_OCCURANCE}" ]]; then
        continue
    fi

    ## Skip, if IP is exist within fixnet/fixvps IP list
    if [[ "${FIXNET_IPS_ARRAY[*]}" =~ "${DENY_IP}" ]]; then
        continue
    fi
        
    echo "Deny IP: ${DENY_IP}"
    echo "IP count: ${IP_COUNT}"
    
    ## Add rule to specified port
    if [[ -z "${UFW_DENY_PORT}" ]]; then
        ufw insert 1 deny from "${DENY_IP}" to any
    else
        ufw insert 1 deny from "${DENY_IP}" to any port "${UFW_DENY_PORT}"
    fi
done < "${IP_LIST_TO_DENY}"

echo "Done."
    
exit 0

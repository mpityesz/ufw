#!/bin/bash

#####
## Check selected log file (default: FAIL2BAN) to banned IPs and create UFW rules.
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

FAIL2BAN_LOG_LAST="/var/log/fail2ban.log"
FAIL2BAN_LOG_BEFORE_LAST="${FAIL2BAN_LOG_LAST}.1"

## TODO: from parameter, like --logfile=path
LOG_TO_CHECK="${FAIL2BAN_LOG_BEFORE_LAST}"
echo "Selected logfile: ${LOG_TO_CHECK}"

echo "Collect banned SSH IPs..."
#cat "${LOG_TO_CHECK}" | grep "[sshd]" | grep -E -v "(localhost|dexter|127\.0\.0\.1)" | grep -E -o "([0-9]{1,3}[\.]){3}[0-9]{1,3}" >> "${UFW_DENY_IP_LIST}"
cat "${LOG_TO_CHECK}" | grep "[sshd]" | grep "[Ban]" | grep -E -o "([0-9]{1,3}[\.]){3}[0-9]{1,3}" > "${UFW_DENY_IP_LIST}"

echo "Sort and unique..."
RESULT=$(sort "${UFW_DENY_IP_LIST}" | uniq -c | sort -bgr)
echo "${RESULT}" > "${UFW_DENY_IP_LIST}"

echo "Done."

exit 0

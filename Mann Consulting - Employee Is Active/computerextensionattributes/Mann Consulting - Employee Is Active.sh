#!/bin/zsh
###############################################################################
# Name:     Mann Consulting - Employee Is Active
# Creator:  Mann Consulting
# Summary:  Extension Attribute to detect if APNs is working correctly.
##
# Usage:    Install as a integer based Extension Attribute
#
# Note:     This script is part of Mann Consulting's Jamf Pro Workflows subscription and is only
#           authorized for use for current subscribers.  It has been distributed to the public as part of our JNUC 2024 session.
#           This script and workflow comes with no support, warranty or guarantee. Use at your own risk, Mann Consulting is
#           not liable for any issues that are caused by this script.
#
#           If you'd like updates or support sign up at https://mann.com/jamf or email support@mann.com for more details
###############################################################################

lockEpochTime=$(ioreg -n Root -d1 -a | grep -A1 CGSSessionScreenLockedTime | tail -1 | cut -d ">" -f 2 | cut -d "<" -f 1)
currentEpoch=$(date +"%s")
time_diff=$(( currentEpoch - lockEpochTime ))
days_diff=$(( time_diff / 86400 ))

if [[ -z $lockEpochTime ]]; then
  echo "<result>0</result>"
else
  echo "<result>$days_diff</result>"
fi

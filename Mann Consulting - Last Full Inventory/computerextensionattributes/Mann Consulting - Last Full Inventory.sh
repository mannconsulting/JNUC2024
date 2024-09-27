#!/bin/zsh
###############################################################################
# Name:     Mann Consulting - Last Full Inventory
# Creator:  Mann Consulting
# Summary:  Extension Attribute to check the last successful Software Update.
##
# Usage:    Install as a date based Extension Attribute
#
# Note:     This script is part of Mann Consulting's Jamf Pro Workflows subscription and is only
#           authorized for use for current subscribers.  It has been distributed to the public as part of our JNUC 2024 session.
#           This script and workflow comes with no support, warranty or guarantee. Use at your own risk, Mann Consulting is
#           not liable for any issues that are caused by this script.
#
#           If you'd like updates or support sign up at https://mann.com/jamf or email support@mann.com for more details
###############################################################################

todayDate=$(date +"%Y-%m-%d %H:%M:%S")

if date -jf "%Y-%m-%d %H:%M:%S" "$todayDate" +%s > /dev/null; then
  echo "<result>$todayDate</result>"
else
  echo "<result>2000-01-01 00:00:01</result>"
fi
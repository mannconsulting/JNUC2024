#!/bin/zsh
###############################################################################
# Name:     Mann Consulting - Last Full Check-in
# Creator:  Mann Consulting
# Summary:  Extension Attribute to check the last successful Software Update.
##
# Usage:    Install as a date based Extension Attribute
#
# Errors:   Output is date based, if a specific error is found then the following date and time will be used to identify them:
#           2000-01-01 00:00:01 - Unknown Error
#           2000-01-01 00:00:02 - MDM Profile not found - The computer must be enrolled manually.
#           2000-01-01 00:00:03 - Client identity certificate missing from /Library/Keychains/System.keychain - The computer must be re-enrolled manually.
#           2000-01-01 00:00:04 - Client identity certificate expired in /Library/Keychains/System.keychain - The computer must be re-enrolled manually.
#
# Notice:   This script is part of Mann Consulting's Jamf Pro Workflows and has been distributed to the public as part of our JNUC 2024 presentation.
#           It is freely available for use by the community under the condition that it is provided “as is,” without any form of support, warranty, or guarantee of functionality, security, or fitness for any specific purpose.
#           Mann Consulting disclaims any and all liability for any damages, losses, or legal claims arising from the use, misuse, or inability to use this script. Users assume full responsibility for testing, deploying, and managing this script in their own environments.
###############################################################################

if [ -f "/Library/Application Support/JAMF/Last_Full_Policy_Run" ]; then
  lastCompletePolicies=$(cat "/Library/Application Support/JAMF/Last_Full_Policy_Run")
else
  echo "<result>2000-01-01 00:00:01</result>"
fi

if date -jf "%Y-%m-%d %H:%M:%S" "$lastCompletePolicies" +%s > /dev/null; then
  echo "<result>$lastCompletePolicies</result>"
else
  echo "<result>2000-01-01 00:00:02</result>"
fi
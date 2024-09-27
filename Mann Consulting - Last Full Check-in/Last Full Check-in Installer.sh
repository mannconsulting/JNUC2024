#!/bin/zsh
###############################################################################
# Name:     Last Full Check-in Installer
# Creator:  Mann Consulting
# Summary:  Installer for Mann's Last Full Check-in Workflow
##
# Usage:    Run to install the workflow. If any of the objects exist already an error will be returned, delete any existing entries if you'd like to update them.
#
# Errors:   Any errors outputted will be from your Jamf server.
#
# Notice:   This script is part of Mann Consulting's Jamf Pro Workflows and has been distributed to the public as part of our JNUC 2024 presentation.
#           It is freely available for use by the community under the condition that it is provided “as is,” without any form of support, warranty, or guarantee of functionality, security, or fitness for any specific purpose.
#           Mann Consulting disclaims any and all liability for any damages, losses, or legal claims arising from the use, misuse, or inability to use this script. Users assume full responsibility for testing, deploying, and managing this script in their own environments.
###############################################################################

echo -n "Enter your Jamf Pro server URL (example https://company.jamfcloud.com): "
read jamfpro_url
echo -n "Enter your Jamf Pro admin account: "
read jamfpro_user

echo -n "Enter the password for the $jamfpro_user account: "
read -s jamfpro_password

jamfpro_url=${jamfpro_url%%/}
fulltoken=$(curl -s -X POST -u "${jamfpro_user}:${jamfpro_password}" "${jamfpro_url}/api/v1/auth/token")
authorizationToken=$(plutil -extract token raw - <<< "$fulltoken" )
baseDir=$(dirname $0)

echo "Uploading categories/Mann Consulting.xml"
curl -sS -H "Authorization: Bearer $authorizationToken" "$jamfpro_url/JSSResource/categories" -H "Content-Type: application/xml" -X "POST" --data-binary "@$baseDir/categories/Mann Consulting.xml"
sleep 20
echo ""

echo "Uploading computerextensionattributes/Mann Consulting - Last Full Check-in.xml"
curl -sS -H "Authorization: Bearer $authorizationToken" "$jamfpro_url/JSSResource/computerextensionattributes" -H "Content-Type: application/xml" -X "POST" --data-binary "@$baseDir/computerextensionattributes/Mann Consulting - Last Full Check-in.xml"
echo ""
sleep 20

echo "Uploading computergroups/Mann Consulting - Last Full Check-in = Fail.xml"
curl -sS -H "Authorization: Bearer $authorizationToken" "$jamfpro_url/JSSResource/computergroups" -H "Content-Type: application/xml" -X "POST" --data-binary "@$baseDir/computergroups/Mann Consulting - Last Full Check-in = Fail.xml"
sleep 20
echo ""

echo "Uploading computergroups/Mann Consulting - Last Full Check-in = Pass.xml"
curl -sS -H "Authorization: Bearer $authorizationToken" "$jamfpro_url/JSSResource/computergroups" -H "Content-Type: application/xml" -X "POST" --data-binary "@$baseDir/computergroups/Mann Consulting - Last Full Check-in = Pass.xml"
sleep 20
echo ""

echo "Uploading policies/zzzz Mann Consulting - Policies Finished.xml"
curl -sS -H "Authorization: Bearer $authorizationToken" "$jamfpro_url/JSSResource/policies" -H "Content-Type: application/xml" -X "POST" --data-binary "@$baseDir/policies/zzzz Mann Consulting - Policies Finished.xml"
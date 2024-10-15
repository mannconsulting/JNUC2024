#!/bin/zsh
###############################################################################
# Name:     Mann Consulting - Verify APNs
# Creator:  Mann Consulting
# Summary:  Extension Attribute to detect if APNs is working correctly.
##
# Usage:    Install as a date based Extension Attribute
#
# Errors:   Output is date based, if a specific error is found then the following date and time will be used to identify them:
#           2000-01-01 00:00:01 - Unknown Error
#           2000-01-01 00:00:02 - MDM Profile not found - The computer must be enrolled manually.
#           2000-01-01 00:00:03 - Client identity certificate missing from /Library/Keychains/System.keychain - The computer must be re-enrolled manually.
#           2000-01-01 00:00:04 - Client identity certificate expired from from /Library/Keychains/System.keychain - The computer must be re-enrolled manually.
#
# Note:     This script is part of Mann Consulting's Jamf Pro Workflows subscription and is only
#           authorized for use for current subscribers.  It has been distributed to the public as part of our JNUC 2024 session.
#           This script and workflow comes with no support, warranty or guarantee. Use at your own risk, Mann Consulting is
#           not liable for any issues that are caused by this script.
#
#           If you'd like updates or support sign up at https://mann.com/jamf or email support@mann.com for more details
###############################################################################

enrolledState=$(/usr/bin/profiles status -type enrollment | grep "MDM enrollment" | cut -d ' ' -f3)
if [[ $enrolledState == "No" ]]; then
  echo "<result>2000-01-01 00:00:02</result>"
  exit
fi

identities=($(security find-identity -v /Library/Keychains/System.keychain | awk '{print $3}' | tr -d '"'))
now_seconds=$(date +%s)

for i in $identities; do
	if [[ $(security find-certificate -c "$i" | grep issu | tr -d '"') == *"JSS BUILT-IN CERTIFICATE AUTHORITY"* ]]; then
		expiry=$(security find-certificate -c "$i" -p | openssl x509 -noout -enddate | cut -f2 -d"=")
    date_seconds=$(date -j -f "%b %d %T %Y %Z" "$expiry" +%s)
    if (( date_seconds > now_seconds )); then
      identityCert=Pass
      break
    else
      identityCert=Expired
    fi
	fi
done

if [[ $identityCert == "Expired" ]]; then
	echo "<result>2000-01-01 00:00:04</result>"
  exit
elif [[ -z $identityCert ]]; then
  echo "<result>2000-01-01 00:00:03</result>"
  exit
fi

zmodload zsh/parameter

waitALongPeriodicallyTime() {
  local -r maxTime=180
  local now=$(date +%s)
  local _path=$(mktemp)
  local priorTime=$now

  for time in ${(@)@}; do
    (command log show --style=syslog --start "$(date -jf "%s" +"%F %R:%S%z" "$time")" --end "$(date -jf "%s" +"%F %R:%S%z" "$priorTime")" --predicate 'subsystem == "com.apple.ManagedClient" && (eventMessage CONTAINS[c] "Received HTTP response (200) [Acknowledged" || eventMessage CONTAINS[c] "Received HTTP response (200) [NotNow")' | tail -1 | cut -d '.' -f 1 >$_path) >/dev/null 2>&1 &
    local jobId=$!
    local timeSpent=0

    while (( $#jobstates > 0 )); do
      if (( $timeSpent > $maxTime )); then
        cat /dev/null >$_path
        pkill -9 -P $jobId
        kill -9 $jobId
        priorTime=$time
        break
      fi
      sleep 1
      timeSpent=$(( $timeSpent + 1 ))
    done

    local output=$(cat $_path)
    if [[ -n "${output}" ]] && date -jf "%Y-%m-%d %H:%M:%S" "$output" +%s &>/dev/null; then
      echo $output
      break
    elif [[ -n "${output}" ]]; then
      cat /dev/null >$_path
    fi
    priorTime=$time
  done
  rm $_path &>/dev/null
}

now=$(date +%s)
delay_1=$(( $now - (3600 * 3) ))
delay_2=$(( $now - (3600 * 16) ))
delay_3=$(( $now - (3600 * 24 * 1) ))
delay_4=$(( $now - (3600 * 24 * 3) ))
delay_5=$(( $now - (3600 * 24 * 14) ))

mdmSuccessfulCommunication=$(waitALongPeriodicallyTime $delay_1 $delay_2 $delay_3 $delay_4 $delay_5)

if ! date -jf "%Y-%m-%d %H:%M:%S" "$mdmSuccessfulCommunication" +%s &>/dev/null; then
  mdmSuccessfulCommunication=$(defaults read "/Library/Application Support/Mann/Timers/com.mann.cis.mdmapns.plist" LastConnected) 2>/dev/null
fi

if date -jf "%Y-%m-%d %H:%M:%S" "$mdmSuccessfulCommunication" +%s &>/dev/null; then
  echo "<result>$mdmSuccessfulCommunication</result>"
  mkdir -p "/Library/Application Support/Mann/Timers"
  defaults write "/Library/Application Support/Mann/Timers/com.mann.cis.mdmapns.plist" LastConnected "$mdmSuccessfulCommunication"
  exit
fi

profileInstallDate=$(profiles list -verbose | grep installationDate | grep _computerlevel | sort | tail -n1 | cut -d ":" -f3- | xargs | cut -d ' ' -f1-2)
if date -jf "%Y-%m-%d %H:%M:%S" "$profileInstallDate" +%s &>/dev/null; then
  echo "<result>$profileInstallDate</result>"
else
  echo "<result>2000-01-01 00:00:01</result>"
fi
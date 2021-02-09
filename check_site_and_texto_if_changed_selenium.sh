#!/usr/bin/env bash

URL="${1:-https://partners.doctolib.fr/hopital-public/perigueux/vaccination-covid?speciality_id=5494&enable_cookies_consent=1}"
message="${2:-ce centre n\'a plus de disponibilités}"
success="${3:-Peut être qu\'il y a des disponibilités désormais...}"

sleepTime=${4:-60s}

echo "Launching this command regularly..."
echo check_site_selenium.py "'$URL'" "'$message'" "'$success'"
check_site_selenium.py "$URL" "$message" "$success"
returncode=$?

while [ "X$returncode" != "X0" ]; do
    echo "'$message' still not found in '$URL'..."
    echo "Sleeping '$sleepTime'..."
    date
    sleep "$sleepTime"
    echo
    check_site_selenium.py "$URL" "$message" "$success"
    returncode=$?
done;

# FreeSMS.py "${URL} semble indiquer qu'il y a des disponibilités désormais."

#!/usr/bin/env bash
#### $$VERSION$$ v0.98-pre2-0-ga597303

# include common functions and definitions
# shellcheck source=test/ALL-tests.inc.sh
source "./ALL-tests.inc.sh"

set -e

# source bashbot.sh functionw
cd "${TESTDIR}" || exit 1
# shellcheck source=./bashbot.sh
source "${TESTDIR}/bashbot.sh" source
# shellcheck source=./bashbot.sh
source "${TESTDIR}/commands.sh" source 

# overwrite get_file for test
get_file() {
	echo "$1"
}

# get telegram input from file
export UPDATE UPD
UPDATE="$(cat "${INPUTFILE}")"
declare -A UPD
source <( printf 'UPD=( %s )' "$(sed <<<"${UPDATE}" -E -e 's/\t/=/g' -e 's/=(true|false)/="\1"/')" )

# run process_message
echo "Check process_message ..."
set -x
{ process_message "0";  set +x; } >>"${LOGFILE}" 2>&1;

USER[ID]="123456789"
CHAT[ID]="123456789"

# output processed input
print_array "USER" "CHAT" "REPLYTO" "FORWARD" "URLS" "CONTACT" "CAPTION" "LOCATION" "MESSAGE" "VENUE" "SERVICE">"${OUTPUTFILE}"
compare_sorted "${REFFILE}" "${OUTPUTFILE}" || exit 1
echo "${SUCCESS}"

cd "${DIRME}" || exit 1

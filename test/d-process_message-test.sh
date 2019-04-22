#!/usr/bin/env bash
#### $$VERSION$$ v0.62-0-g5d5dbae

# include common functions and definitions
# shellcheck source=test/ALL-tests.inc.sh
source "./ALL-tests.inc.sh"

set -e

# source bashbot.sh functionw
cd "${TESTDIR}" || exit 1
# shellcheck source=./bashbot.sh
source "${TESTDIR}/bashbot.sh" source

# overwrite get_file for test
get_file() {
	echo "$1"
}

# get telegram input from file
export UPDATE
UPDATE="$(cat "${INPUTFILE}")"

# run process_message with and without phyton
echo "Check process_message ..."
for i in 1 2
do
	[ "${i}" = "1" ] && ! which python >/dev/null 2>&1 && continue
	[ "${i}" = "1" ] && echo "  ... JsonDecode Phyton"
	[ "${i}" = "2" ] && echo "  ... JsonDecode Bash" && export BASHDECODE="yes"
	set -x
	{ process_message "0";  set +x; } >>"${LOGFILE}" 2>&1;

	# output processed input
	print_array "USER" "CHAT" "REPLYTO" "FORWARD" "URLS" "CONTACT" "CAPTION" "LOCATION" "MESSAGE" >"${OUTPUTFILE}"
	diff -c "${REFFILE}" "${OUTPUTFILE}" || exit 1
	echo "${SUCCESS}"
done

cd "${DIRME}" || exit 1
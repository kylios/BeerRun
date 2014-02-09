
function exit_with_message() {
	CODE=$1
	MESSAGE="$2"

	if [ $CODE = 2 ]; then
		MESSAGE="ERROR: $MESSAGE"
		echo "$MESSAGE" 1>&2
	else
		echo "$MESSAGE"
	fi

	exit $CODE
}

function check_command() {
	COMMAND="$1"
	command -v "$COMMAND" >/dev/null 2>&1 || { \
		exit_with_message 2 "Command '$COMMAND' not found."
	}
	return 0
}



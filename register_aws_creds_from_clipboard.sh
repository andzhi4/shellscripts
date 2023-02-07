#!/bin/bash

# Fucntion to append AWS credentials from the clipboard to a credentials file
# It relies on AWS_CRED_FILE env variable being set to the full path of the credentials file
function register_aws_creds_from_clipboard() {
	if [ -z "$AWS_CRED_FILE" ]; then
		echo "Error: AWS_CRED_FILE environment variable is not set."
		return 1
	fi
	temp_file=$(mktemp /tmp/clipboard.XXXXXX)
	pbpaste > "$temp_file"
	# The first line of the pasted contents is [profile_name]
	first_line="$(head -n 1 "$temp_file")"
	# Strip [] from the line
	default_profile="${first_line:1:-1}"
	if grep -q 'aws_access_key_id' "$temp_file"; then
		# Remove last 5 lines from the credentials file
		tac "$AWS_CRED_FILE" | awk 'NR > 5' | tac > "$AWS_CRED_FILE".tmp
		mv "$AWS_CRED_FILE".tmp "$AWS_CRED_FILE"
		# Append fresh credentials
		cat "$temp_file" >> "$AWS_CRED_FILE"
		echo "AWS credentials updated in \033[0;34m$AWS_CRED_FILE\033[0m"
		# Set the default profile for AWS CLI
		export AWS_PROFILE=$default_profile
		echo "Default AWS profile is \033[0;34m$AWS_PROFILE\033[0m"
		# Check caller identity
		echo "AWS caller identity:"
		aws sts get-caller-identity | jq
	else
	echo "Clipboard contents does not seem to have aws_access_key_id. Exiting..."
	fi
	rm "$temp_file"
}
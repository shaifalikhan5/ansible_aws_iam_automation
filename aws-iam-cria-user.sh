#!/bin/bash
# Purpose: Automates user creation in AWS
# Usage: ./aws-iam-create-user.sh <input CSV file format>
# Input file format: users,group,password
# Author: Shaif Ali Khan
# ------------------------------------------

INPUT=$1    # The first argument provided to the script is taken as the input file
OLDIFS=$IFS # Saves the current IFS (Internal Field Separator)
IFS=','     # Sets IFS to comma, as we are reading a CSV file

# Checks if the input file exists, if not, exits with code 99
[ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }

# Checks if dos2unix is installed, which converts the file to Unix format if it has Windows line endings
command -v dos2unix >/dev/null || { echo "dos2unix utility not found. Please install dos2unix before running the script."; exit 1; }

# Convert the input file to Unix format
dos2unix $INPUT

# Reads each line in the CSV file and processes the user, group, and password columns
while read -r user group password || [ -n "$user" ]
do
    # Skips the header line with column names
    if [ "$user" != "user" ]; then
        # Creates an IAM user in AWS
        aws iam create-user --user-name $user
        # Sets a login profile with a password for the user and requires a password reset at first login
        aws iam create-login-profile --password-reset-required --user-name $user --password $password
        # Adds the user to the specified IAM group
        aws iam add-user-to-group --group-name $group --user-name $user
    fi
done < $INPUT

# Restores the original IFS
IFS=$OLDIFS

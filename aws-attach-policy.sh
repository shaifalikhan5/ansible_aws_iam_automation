#!/bin/bash
# Purpose: Automates attaching policies to AWS groups
# Usage: ./aws-create-policy.sh <input CSV file format>
# Example: ./aws-create-group.sh users.csv
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

# Reads each line in the CSV file and processes the group column
while read -r user group password || [ -n "$group" ]
do
    # Skips the header line with column names
    if [ "$group" != "group" ]; then

        # Attaches policies based on the group type
        if [ "$group" == "DBA" ]; then
            aws iam attach-group-policy --policy-arn arn:aws:iam::aws:policy/AmazonRDSFullAccess --group-name $group
            aws iam attach-group-policy --policy-arn arn:aws:iam::248420709401:policy/forceMFA --group-name $group        
        fi

        if [ "$group" == "CloudAdmin" ]; then
            aws iam attach-group-policy --policy-arn arn:aws:iam::aws:policy/AdministratorAccess --group-name $group
            aws iam attach-group-policy --policy-arn arn:aws:iam::248420709401:policy/forceMFA --group-name $group        
        fi

        if [ "$group" == "LinuxAdmin" ]; then
            aws iam attach-group-policy --policy-arn arn:aws:iam::aws:policy/AmazonEC2FullAccess --group-name $group 
            aws iam attach-group-policy --policy-arn arn:aws:iam::248420709401:policy/forceMFA --group-name $group       
        fi

        if [ "$group" == "RedesAdmin" ]; then
            aws iam attach-group-policy --policy-arn arn:aws:iam::aws:policy/AmazonVPCFullAccess --group-name $group
            aws iam attach-group-policy --policy-arn arn:aws:iam::248420709401:policy/forceMFA --group-name $group        
        fi

        if [ "$group" == "Estagiarios" ]; then
            aws iam attach-group-policy --policy-arn arn:aws:iam::aws:policy/ReadOnlyAccess --group-name $group
            aws iam attach-group-policy --policy-arn arn:aws:iam::248420709401:policy/forceMFA --group-name $group        
        fi
    fi
done < $INPUT

# Restores the original IFS
IFS=$OLDIFS

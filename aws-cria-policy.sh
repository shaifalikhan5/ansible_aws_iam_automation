#!/bin/bash
# Purpose: Automates the creation of policies in AWS
# Usage: ./aws-create-policy.sh <policy-name> <input file format .txt>
# Example: ./aws-create-policy.sh forceMFA force_mfapolicy.txt
# Input file format: users,group,password
# Author: Shaif Ali Khan
# ------------------------------------------

# Creates an IAM policy in AWS using the provided policy name and policy document file
aws iam create-policy --policy-name $1 --policy-document file://$2

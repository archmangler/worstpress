#!/usr/bin/bash
#Terraform bootstrap environment variables for Azure Cloud

#Your azure credentials must be stored in ../.access.sh
#source ../.access.sh

#this code identifies a customer (it's a kind of customer identifier)
appName="blog"

#6-letter business code identifies the customer or internal business organisation
#sharing the tenant
customerCode="hybent"

#set the default bootstrap account here
#Formal convention is:
#${subscriptionName}-${appName}-${locCode}
subscription="Pay-As-You-Go"

#This credential must be obtained from pre-existing
#
#storage_account_key=""

state_file_storage_account="lvl-0-state"
state_file_storage_account_key="${storage_account_key}"
state_file_container="states-${customerCode}-${subscription}"
state_file_key="tf-${subscription}-${appName}.tfstate"

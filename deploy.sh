#!/usr/bin/bash
#deployment script to stand up the entire stack or tear
#it down

operation=$1

function bootstrap_terraform_state () {
  #create a remote state storage account and container
  #for storing terraform state
  echo "bootstrapping infrastructure state ..."
}

function deploy_infrastructure () {
  #deploy containerisation platform
  #and supporting IaaS components
  echo "deploying infrastructure and platform ..."
}

function deploy_application () {
  #deploy application containers+configuration
  echo "deploying applications ..."
}

function show_deploy_parameters () {
  #show results of the deployment
  echo "dumping final deploy status ..."
}

function decommission_service (){
  #tear down the entire deployment (application, infra, data)
  #and state
  #1. Delete application
  #2. Remove DNS 
  #3. Remove Containerisation platform
  #4. Wipe temporary access credentials
  echo "decommissioning the entire service platform ..."
}


if [[ ${operation} == "decomm" ]]; then
  decommission_service
fi


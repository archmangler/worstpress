#!/usr/bin/bash
#deployment script to stand up the entire stack or tear
#it down
#
#Usage:
#
#Deploy infra,platform and application: ./deploy.sh deploy
#Destroy and remove infra, platform and app: ./deploy.sh decomm
#
#NOTE: Source Azure env variables first with source ../.access.sh

operation=$1

#Build configuration parameters from environment variables
#this code identifies a customer application
appName="blog"

#6-letter business code identifies the customer or internal business organisation
#sharing the tenant
customerCode="hybent"
environment="uat"

#location and naming of terraform state storage resource group
bootstrap_location="southeastasia"
bootstrap_resource_group_name="${customerCode}-${bootstrap_location}-${environment}"
bootstrap_storage_sku="Standard_ZRS"

#Azure subscription name we're deploying this infrastructure in
subscription="Pay-As-You-Go"

state_file_storage_account="${customerCode}state"
state_file_storage_account_key=""
state_file_container="states-${customerCode}-${environment}"
state_file_key="tf-${subscription}-${appName}.tfstate"

function init {

  echo "debug> terraform init -no-color -backend=true -backend-config storage_account_name=${state_file_storage_account} -backend-config container_name=${state_file_container} -backend-config access_key=${state_file_storage_account_key} -backend-config key=tf-${subscription}-${appName}.tfstate"

  terraform init \
    -no-color \
    -backend=true \
    -backend-config storage_account_name=${state_file_storage_account} \
    -backend-config container_name=${state_file_container} \
    -backend-config access_key=${state_file_storage_account_key} \
    -backend-config key="tf-${subscription}-${appName}.tfstate"
}

function plan {
  terraform plan \
    -no-color \
    -refresh=true \
    -var-file=terraform.tfvars \
    -out=${subscription}.tfplan
}

function apply {
  terraform apply \
    -no-color \
    ${subscription}.tfplan
}

function destroy {
  terraform destroy \
    -refresh=false \
    -var-file=terraform.tfvars \
    -auto-approve
}

function bootstrap_terraform_state () {
  #create a remote state storage account and container
  #for storing terraform state
  #follow sensible naming convention in resource creation

  echo "bootstrapping infrastructure state ..."

  echo "creating bootstrap resource group ..."
  echo "az group create \
    --name ${bootstrap_resource_group_name} \
    --location ${bootstrap_location}"

  az group create \
    --name ${bootstrap_resource_group_name} \
    --location ${bootstrap_location}

  echo "creating bootstrap state storage account ..."
  echo "az storage account create \
    --name ${state_file_storage_account} \
    --resource-group ${bootstrap_resource_group_name} \
    --location ${bootstrap_location} \
    --sku ${bootstrap_storage_sku} \
    --encryption-services blob"

  az storage account create \
    --name ${state_file_storage_account} \
    --resource-group ${bootstrap_resource_group_name} \
    --location ${bootstrap_location} \
    --sku ${bootstrap_storage_sku} \
    --encryption-services blob

  echo "creating bootstrap state container ..."

  connection_string=$(az storage account show-connection-string \
    --resource-group ${bootstrap_resource_group_name} \
    --name  ${state_file_storage_account} \
    --query connectionString )

  #this key is required for access to terraform backend state
  state_file_storage_account_key=$(az storage account keys list \
    --resource-group ${bootstrap_resource_group_name} \
    --account-name ${state_file_storage_account} | jq -r '.[0].value')

  echo "az storage container create \
    --name ${state_file_container} \
    --connection-string ${connection_string}"

  az storage container create \
    --name ${state_file_container} \
    --connection-string ${connection_string}
}

function cleanup () {
  cd infrastructure/
  rm -rf .terraform/
  rm -rf terraform.tfstate*
  cd ..
}

function get_kubeconfig () {
  ../utilities/getkubectl.sh
  echo "extracting and saving kubeconfig ..."
  mkdir -p ~/.kube/
  terraform output -json | jq -r '.kube_config| .value' > ~/.kube/config
  #assuming kubectl client utility is available
  kubectl get nodes
  kubectl get ns
}

function deploy_infrastructure () {
  #deploy containerisation platform and supporting IaaS components
  echo "deploying infrastructure and platform ..."
  init
  plan
  apply
  #write kubeconfig to ~/.kube/config
  #and test
  get_kubeconfig
}

function deploy_application () {
  #deploy application containers+configuration
  echo "deploying applications ..."
  #create namespaces
  kubectl apply -f application/application_namespace.yml
  #deploy application charts
  #deploying wordpress from Helm charts ...
  helm install --namespace worstpress wordpress stable/wordpress
}

function show_deploy_parameters () {
  #show results of the deployment
  echo "dumping final deploy status ..."
  echo "==============================="
  terraform output -json

}

function decommission_service (){
  #tear down the entire deployment (application, infra, data)
  #and state
  #1. Delete application
  #2. Remove DNS 
  #3. Remove Containerisation platform
  #4. Wipe temporary access credentials
  echo "decommissioning the entire service platform ..."

  #tear down infra/platform
  init
  destroy
}

#setup terraform remote state storage
bootstrap_terraform_state

if [[ ${operation} == "plan" ]]; then
  cd infrastructure/
  init
  plan
  cd ../
  cleanup
fi

if [[ ${operation} == "deploy" ]]; then
  cd infrastructure/
  deploy_infrastructure
  show_deploy_parameters
  cd ../
  cleanup
  deploy_application
fi

if [[ ${operation} == "decomm" ]]; then
  cd infrastructure/
  decommission_service
  cd ../
  cleanup
fi

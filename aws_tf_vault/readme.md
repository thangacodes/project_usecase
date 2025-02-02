## Vault:

HashiCorp Vault is an open-source tool designed for managing and securing sensitive data, such as secrets, passwords, API keys, certificates, and encryption keys.

## Installation and Configuration:

```bash
This page contains instructions on how to install and configure a Vault development server locally on macOS.
brew tap hashicorp/tap
brew install hashicorp/tap/vault
brew upgrade hashicorp/tap/vault
vault -version

### AWS CLI 
aws --version
aws configure list-profiles
aws configure --profile <please enter the name that you wanted to setup>
aws s3 ls --profile newtd

## REMOVE PROFILE 
aws configure --profile <profile_name> unset 

## Set the VAULT_ADDR Environment Variable:
export VAULT_ADDR=http://127.0.0.1:8200

## To log in to the Vault UI on macOS using the development method, you need a token. Generate the token using the method below.
Go to Terminal, run the command below,
vault status
vault token create -address=http://127.0.0.1:8200     //Keep the token in safer custody.               

## VAULT CLI to create secrets
vault kv put secret/db-username-secret db_username=admin
vault kv put secret/db-password-secret db_password=xxxxxx

vault kv put secret/mac-username mac_username=tdmac
vault kv put secret/mac-password mac_password=xxxxxx

## LIST:
vault kv list secret
vault kv list -format=json secret //to list the secrets in JSON format

## GET:
vault kv get secret
vault kv get secret/mac-username  //to view the content of it
vault kv get secret/mac-password //to view the content of it
vault kv get -format=json secret/mac-username  //to get the secrets in JSON format for easier parsing
vault kv get -format=json secret/mac-password //to get the secrets in JSON format for easier parsing

## DELETE:
vault kv delete secret/mac-password
vault kv delete secret/mac-username

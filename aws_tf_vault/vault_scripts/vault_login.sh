#!/bin/bash
echo "The Script was executed at: " $(date '+%Y-%m-%d %H-%M-%S')
echo "Exporting vault address to the local system (macOS)"

# Variables
vault_address="http://127.0.0.1:8200"
export VAULT_ADDR=$vault_address
echo "To cross verify that the VAULT_ADDR is exported properly:"
env | grep -i 'VAULT_ADDR'

echo "Login to the Vault UI using root credentials"
vault login -method=token

echo "Checking the secrets get/list/delete using case statement.."
read -p "What operation would you like to perform (get/list/delete)? " ACTION
echo "You entered the action: $ACTION"

# Perform actions based on user input
if [[ $ACTION == "get" ]]; then
    echo "Performing get operation using vault CLI method.."
    vault kv get secret
elif [[ $ACTION == "list" ]]; then
    echo "Performing list operation using vault CLI method.."
    vault kv list secret/dev
    vault kv list secret/mac
    vault kv list secret/postgres
elif [[ $ACTION == "delete" ]]; then
    echo "Performing delete operation using vault CLI method.."
    vault kv delete secret/dev
    vault kv delete secret/mac
    vault kv delete secret/postgres
else
    echo "You chose a wrong option. Please select one of the following actions: (get/list/delete)"
fi
exit 0

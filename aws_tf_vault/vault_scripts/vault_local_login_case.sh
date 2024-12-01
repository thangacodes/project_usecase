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

# Perform actions based on user input using a case statement
case $ACTION in
    "get")
        echo "Performing get operation using vault CLI method.."
        vault kv get secret
        ;;
    "list")
        echo "Performing list operation using vault CLI method.."
        vault kv list secret/dev
        vault kv list secret/mac
        vault kv list secret/postgres
        ;;
    "delete")
        echo "Performing delete operation using vault CLI method.."
        vault kv delete secret/dev
        vault kv delete secret/mac
        vault kv delete secret/postgres
        ;;
    *)
        echo "You chose a wrong option. Please select one of the following actions: (get/list/delete)"
        ;;
esac
exit 0

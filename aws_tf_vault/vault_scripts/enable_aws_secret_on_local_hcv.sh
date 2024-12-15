#!/bin/bash
echo "The script to enable AWS on local Vault server was executed at: $(date '+%Y-%m-%d %H:%M:%S')"
# Variables
LOCAL_HCV="http://127.0.0.1:8200"  # Set the correct address (http OR https)
read -p "Do you want to enable AWS Vault on the locally installed Vault server? (yes/no): " ANS
echo "User input is: $ANS"
if [[ "$ANS" == "yes" ]]; then
    echo "User wants to configure AWS secrets engine on the locally installed Vault server."

    # Check if vault is installed
    if ! command -v vault &> /dev/null; then
        echo "Vault command not found. Please install Vault before proceeding."
        exit 1
    fi
    # Ensure VAULT_ADDR is set
    if [[ -z "$VAULT_ADDR" ]]; then
        echo "VAULT_ADDR is not set in the environment variables, hence exporting it..."
        export VAULT_ADDR=$LOCAL_HCV  # Ensure it is set to http
    else
        echo "VAULT_ADDR is already set in the environment variables: $VAULT_ADDR"
    fi
    # Show the current VAULT_ADDR in the environment
    echo "Current VAULT_ADDR in the environment: $VAULT_ADDR"
    # Enable the AWS secrets engine
    echo "Enabling AWS secrets engine on Vault..."
    vault secrets enable aws
    # List all enabled secrets engines
    echo "Listing enabled secrets engines:"
    vault secrets list
    # Wait for 2 seconds
    echo "Pausing for 2 seconds..."
    sleep 2
    # Ask the user if they want to disable the AWS secrets engine
    read -p "Do you want to disable the AWS Vault secrets engine? (yes/no): " DISABLE_ANS
    echo "User input is: $DISABLE_ANS"
    if [[ "$DISABLE_ANS" == "yes" ]]; then
        echo "User wants to disable the AWS secrets engine on the locally installed Vault server."

        # Disable the AWS secrets engine
        echo "Disabling AWS secrets engine..."
        vault secrets disable aws

        # Verify that AWS secrets engine has been disabled
        echo "Listing secrets engines after disabling AWS engine:"
        vault secrets list
    else
        echo "User doesn't want to disable the AWS secrets engine on the local Vault server."
    fi
    # Ask the user if they want to unset VAULT_ADDR
    read -p "Do you want to unset the VAULT_SERVER_URL? (yes/no): " UNSET
    echo "User input is: $UNSET"

    if [[ "$UNSET" == "yes" ]]; then
        echo "User wants to unset the Vault Address..."
        # Unset VAULT_ADDR
        unset VAULT_ADDR
        echo "VAULT_ADDR has been unset."
    else 
       echo "User doesn't want to unset the VAULT_ADDR."
    fi
else
    echo "User doesn't want to configure AWS secrets engine on the local Vault server."
fi
exit 0

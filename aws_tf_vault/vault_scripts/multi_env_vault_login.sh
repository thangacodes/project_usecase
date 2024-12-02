#!/bin/bash
IP=$(ipconfig getifaddr en0)
# Getting macOS IP address
echo "Your macOS IP address is: " $IP
# Print script start info
echo "The script was executed at: $(date '+%Y-%m-%d %H-%M-%S')"
echo "Scripted method for logging into Vault servers in multiple environments, such as DEV, STAGE, and PROD"

# Define Vault server URLs
dev_vault_address="https://dev.cloudbird.fun"
staging_vault_address="https://stage.cloudbird.fun"
prod_vault_address="https://prod.cloudbird.fun"
username="devuser"

# Function to login to Vault server
vault_login() {
    local vault_address=$1
    export VAULT_ADDR=$vault_address
    echo "Connecting to Vault at $VAULT_ADDR using OIDC method..."
    echo "To cross-verify that the VAULT_ADDR is exported properly:"
    env | grep -i 'VAULT_ADDR'
    
    # Attempt to login, exit on failure
    if ! vault login -method=oidc username=$username; then
        echo "Failed to login to Vault at $vault_address. Exiting script."
        exit 1
    fi
}

# Function to set VAULT_ADDR permanently
set_vault_addr_permanently() {
    local vault_address=$1
    echo "Setting VAULT_ADDR permanently to $vault_address..."

    # Add to the appropriate user's shell configuration file (~/.bashrc for bash users, ~/.zshrc for zsh users)
    echo "export VAULT_ADDR=$vault_address" >> ~/.zshrc
    echo "VAULT_ADDR=$vault_address set in ~/.zshrc"
    
    # Source the updated file to apply changes immediately
    source ~/.zshrc
}

# Prompt user for the environment to connect to
read -p "Which environment would you like to connect to (dev/stage/prod)? " ENVIRONMENT
echo "You entered the environment: $ENVIRONMENT"

# Perform actions based on user input
case $ENVIRONMENT in
    dev)
        vault_login $dev_vault_address
        set_vault_addr_permanently $dev_vault_address
        ;;
    stage)
        vault_login $staging_vault_address
        set_vault_addr_permanently $staging_vault_address
        ;;
    prod)
        vault_login $prod_vault_address
        set_vault_addr_permanently $prod_vault_address
        ;;
    *)
        echo "Invalid environment choice. Please choose one of the following: dev, stage, or prod."
        exit 1
        ;;
esac

# Success message (if the script reaches this point)
echo "Successfully logged in to Vault."
exit 0

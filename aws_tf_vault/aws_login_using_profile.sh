#!/bin/bash
echo "The Script was executed at: " $(date '+%Y-%m-%d %H:%M:%S')
# Checking AWS CLI version
aws --version
# List the existing AWS profiles
echo "Existing AWS profiles: "
existing_profiles=$(aws configure list-profiles)
# Check if there are any existing profiles
if [ -z "$existing_profiles" ]; then
    echo "No AWS profiles found."
else
    echo "$existing_profiles"
fi
# Ask user whether they want to use an existing profile or add a new one
read -p "Do you want to use an existing profile or add a new one? (existing/new): " choice

# Case handling based on user input
if [[ "$choice" == "existing" ]]; then
    read -p "Please enter the name of the existing profile you want to use: " profile_name
    if grep -q "$profile_name" <<< "$existing_profiles"; then
        echo "You have selected the existing profile: $profile_name"
        echo "Profile set to $profile_name"
        # Checking able to fetch s3 bucket using the profile
        listing_s3_buckets=$(aws s3 ls --profile $profile_name)
        echo "I see the following S3 buckets: "
        echo $listing_s3_buckets
    else
        echo "Error: Profile '$profile_name' does not exist. Please choose a valid profile."
    fi
elif [[ "$choice" == "new" ]]; then
    # Prompt user for new profile details
    read -p "Enter the name for the new profile: " new_profile
    echo "You have selected to create a new profile: $new_profile"
    # Using aws configure to input new profile details
    aws configure --profile $new_profile
    echo "New profile '$new_profile' has been added successfully."
else
    echo "Invalid choice. Please choose 'existing' or 'new'."
    exit 1
fi

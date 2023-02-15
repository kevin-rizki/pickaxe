#!/bin/bash creating-multiple-users.sh

# --- This script creat multiple users based on number input ---

# Validate if the script being run using administrative privilege or not
if [ $(id -u) -ne 0 ]; then
    echo "This script must be run with administrative privileges"
    exit 1
fi

# Input number n from admin
while true; do
    read -p "Enter the number of users to create (must be a positive integer greater than 1): " n
    if [[ ! $n =~ ^[1-9][0-9]*$ ]]; then
        echo "Invalid input, please enter a positive integer greater than 1"
    else
        break
    fi
done

# Looping n times
for ((i=1;i<=n;i++)); do
    while true; do
        read -p "Enter the username for user $i: " username
        if [[ ! $username =~ ^[a-z_][a-z0-9_-]*[$]?$ ]]; then
            echo "Invalid username syntax, please try again"
        elif id -u "$username" >/dev/null 2>&1; then
            echo "User $username already exists, please try again"
        else
            break
        fi
    done
    password=$(openssl rand -base64 12)

    # Create the user with the generated password
    useradd -m -p $(openssl passwd -1 "$password") "$username"

    # Check if the user was created successfully
    if [ $? -eq 0 ]; then
        echo "User $username created successfully"
        # Add username and password to arrays
        usernames[$i]=$username
        passwords[$i]=$password
    else
        echo "Error creating user $username"
        exit 1
    fi

    # Force user to change password on first login
    chage -d 0 "$username"
done

# Display a list of all usernames and passwords created
echo "Here are the usernames and passwords for the newly created users:"

for ((i=1;i<=n;i++)); do
    echo "${usernames[$i]}: ${passwords[$i]}"
done
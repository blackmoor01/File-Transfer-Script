#!/bin/bash

# Function to display a welcome message
echo "========================================"
echo "  EC2  FILE TRANSFER HELPER (SCP)       "
echo "========================================"

# Prompt the user for the public IP address of the EC2 instance
while true; do
	read -p "Enter the public IP address of the EC2 instance: " ec2_ip
	# Validate that the input is not empty and follows a basic IP pattern
	if [[ "$ec2_ip" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
		break
	else
		echo "Invalid IP address. Please enter a valid public IP."
	fi
done


# Prompt the user for the path to the SSH Key File
while true; do
	read -p "Enter the full path to your SSH key file (e.g., /home/user/keypair.pem):" key_file
	# Validate that the file exist
	if [ -f "$key_file" ]; then
		break
	else
		echo "The specified key file does not exist. Please check the path."
	fi
done

# Prompt the user for the username (default is 'ubuntu')
read -p "Enter the username (default is 'ubuntu'): " username

# Set default username to 'ubuntu' if not provided
if [ -z "$username" ]; then
	username="ubuntu"
fi

# Prompt the user for the upload or download direction
while true; do
	read -p "Do you want to upload or download: (U/D): " transfer_direction
	if [[ "$transfer_direction" == "u" || "$transfer_direction" == "d" ]]; then
		break
	else
		echo "Invalid option. Please enter 'u' for upload or 'd' for download."
	fi
done

# Prompt for the local file path
read -p "Enter the local file path (e.g., /homr/user/myfile.txt): " local_file

# Prompt for the remote file path
read -p "Enter the remote file path (e.g., /home/ubuntu/): " remote_file


# Perform the file transfer based on user's choice
if [ "$transfer_direction" == "u" ]; then
	# Upload file from local to EC2
	echo "Uploading $local_file to $username@$ec2_ip:$remote_file..."
	scp -i "$key_file" "$local_file" "$username@$ec2_ip:$remote_file"
	if [ $? -eq 0 ]; then
		echo "File uploaded successfully!"
	else
		echo "Failed to upload file."
	fi
else
	# Download file from EC2 to local
	echo "Downloading $username@$ec2_ip:$remote_file to $local_file..."
	scp -i "$key_file" "$username@$ec2_ip:$remote_file" "$local_file"
	if [ $? -eq 0 ]; then
		echo "File downloaded successfully!"
	else
		echo "Failed to download file"
	fi
fi


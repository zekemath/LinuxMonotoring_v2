#!/bin/bash

# Check the number of parameters
if [ "$#" -ne 6 ]; then
    echo "Usage: $0 <absolute_path> <number_of_folders> <folder_name_chars> <number_of_files> <file_name_chars> <file_size_in_kb>"
    exit 1
fi

# Parameters
absolute_path=$1
number_of_folders=$2
folder_name_chars=$3
number_of_files=$4
file_name_chars=$5
file_size_in_kb=$(echo $6 | sed 's/кб//')

# Check the length of folder and file name characters
if [ ${#folder_name_chars} -gt 7 ] || [ ${#file_name_chars} -gt 7 ]; then
    echo "Error: Folder and file name characters must be no more than 7 characters."
    exit 1
fi

# Check file size
if [ $file_size_in_kb -gt 100 ]; then
    echo "Error: File size must be no more than 100 KB."
    exit 1
fi

# Get the current date in DD.MM.YY format
current_date=$(date +%d%m%y)

# Function to generate folder name
generate_folder_name() {
    local chars=$1
    local length=${#chars}
    local name=""
    local i=0
    while [ $i -lt 4 ]; do
        name+=${chars:$((i % length)):1}
        ((i++))
    done
    echo "${name}_${current_date}"
}

# Function to generate file name
generate_file_name() {
    local chars=$1
    local length=${#chars}
    local name=""
    local i=0
    while [ $i -lt 4 ]; do
        name+=${chars:$((i % length)):1}
        ((i++))
    done
    local extension=${chars: -3}
    echo "${name}.${extension}"
}

# Function to check free space
check_free_space() {
    local free_space=$(df -k / | awk 'NR==2 {print $4}')
    if [ $free_space -lt 1048576 ]; then
        echo "Error: Less than 1 GB of free space left."
        exit 1
    fi
}

# Create a log file in the home directory
log_file="${HOME}/log_creation_$(date +%d%m%y).log"
touch $log_file

# Create folders and files
for ((i=1; i<=number_of_folders; i++)); do
    folder_name=$(generate_folder_name $folder_name_chars)
    folder_path="${absolute_path}/${folder_name}"
    mkdir -p $folder_path
    echo "Created folder: ${folder_path} $(date +%Y-%m-%d_%H:%M:%S)" >> $log_file
    
    for ((j=1; j<=number_of_files; j++)); do
        file_name=$(generate_file_name $file_name_chars)
        file_path="${folder_path}/${file_name}"
        dd if=/dev/zero of=$file_path bs=1K count=$file_size_in_kb 2>/dev/null
        echo "Created file: ${file_path} $(date +%Y-%m-%d_%H:%M:%S) ${file_size_in_kb}KB" >> $log_file
        check_free_space
    done
done

echo "Script completed successfully."
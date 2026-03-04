#!/bin/bash

PROJECTS=($(ls -l /home/gns3/GNS3/projects/ | grep '^d' | awk '{print $9}'))
echo "Available Projects:"
count=1
for PROJ in "${PROJECTS[@]}"; do
    PROJ_NAME=$(ls /home/gns3/GNS3/projects/$PROJ | grep .gns3 )
    echo "[$count] $PROJ_NAME : $PROJ"
    count=$((count+1))
done

# Prompt user to select a project
read -p "Enter the number of the project you want to export configurations from: " PRO
if ! [[ "$PRO" =~ ^[0-9]+$ ]] || [ "$PRO" -lt 1 ] || [ "$PRO" -gt ${#PROJECTS[@]} ]; then
    echo "Invalid selection. Exiting."
    exit 1
fi
SELECTED_PROJECT=${PROJECTS[$((PRO-1))]}
echo "You selected: $SELECTED_PROJECT"

PROJECT_ID=$SELECTED_PROJECT
EXPORT_DIR=/home/gns3/ConfigExports/
mkdir -p $EXPORT_DIR
PROJECT_DIR=/home/gns3/GNS3/projects/$PROJECT_ID
DEVICE_IDS=$(ls -l $PROJECT_DIR/project-files/dynamips | grep '^d' | awk '{print $9}')

for DEVICE in $DEVICE_IDS; do
    CONTENT=$(strings "$PROJECT_DIR/project-files/dynamips/$DEVICE/"*nvram)
    DEVICE_NAME=$(echo "$CONTENT" | grep -m 1 -i "^hostname" | awk '{print $2}'| tr -d '\r')
    echo "Exporting configuration for $DEVICE_NAME..."
    echo "$CONTENT" > "$EXPORT_DIR/$DEVICE_NAME.txt"
done
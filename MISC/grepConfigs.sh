#!/bin/bash

PROJECT_ID=$1
EXPORT_DIR=/home/gns3/ConfigExports/
PROJECT_DIR=/home/gns3/GNS3/projects/$PROJECT_ID
DEVICE_IDS=$(ls -l $PROJECT_DIR/project-files/dynamips | grep '^d' | awk '{print $9}')

for DEVICE in $DEVICE_IDS; do
    CONTENT=$(cat $PROJECT_DIR/project-files/dynamips/$DEVICE/*nvram)
    DEVICE_NAME=$(echo "$CONTENT" | grep -i "hostname" | awk '{print $2}')
    echo "Exporting configuration for $DEVICE_NAME..."
    echo "$CONTENT" > "$EXPORT_DIR/$DEVICE_NAME.txt"
done
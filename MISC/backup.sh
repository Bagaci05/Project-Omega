#!/bin/bash
mv /drive/projectOmega.tar.zst /drive/projectOmega.old.tar.zst
tar --zstd -cSf /drive/projectOmega.tar.zst \
    --exclude='project-files/captures' \
    --exclude='*.log' \
    --exclude='*.tmp' \
    --exclude='tmp' \
    /home/gns3/GNS3/projects/7389ec78-e6dd-4c47-9959-a0ca431a06c1
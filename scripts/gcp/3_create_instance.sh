#!/bin/bash

gcloud compute instances create $GCP_INSTANCE_NAME \
    --machine-type=$GCP_MACHINE_TYPE \
    --image-family=$GCP_IMAGE_FAMILY \
    --image-project=$GCP_IMAGE_PROJECT \
    --boot-disk-size=$GCP_DISK_SIZE \
    --boot-disk-type=pd-ssd \
    --network=my-vpc \
    --tags=ssh-access,opensearch-access
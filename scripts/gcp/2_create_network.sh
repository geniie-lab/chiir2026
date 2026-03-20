#!/bin/bash

gcloud compute networks create my-vpc --subnet-mode=auto
gcloud compute firewall-rules create allow-ssh \
    --network=my-vpc \
    --allow=tcp:22 \
    --source-ranges=0.0.0.0/0 \
    --target-tags=ssh-access
gcloud compute firewall-rules create allow-opensearch \
    --network=my-vpc \
    --allow=tcp:9200 \
    --source-ranges=0.0.0.0/0 \
    --target-tags=opensearch-access
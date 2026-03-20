#!/bin/bash

gcloud compute instances delete $GCP_INSTANCE_NAME
gcloud compute firewall-rules delete allow-ssh --quiet
gcloud compute firewall-rules delete allow-opensearch --quiet
gcloud compute networks delete my-vpc --quiet
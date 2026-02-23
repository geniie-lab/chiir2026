# How to transfer an opensearch container

Create a container

```bash
docker run -d \
  --name opensearch-node \
  -v ~/Workspace/docker-mount/opensearch:/usr/share/opensearch/data \
  -p 9200:9200 -p 9600:9600 \
  -e "discovery.type=single-node" \
  -e "DISABLE_SECURITY_PLUGIN=true" \
  -e "DISABLE_INSTALL_DEMO_CONFIG=true" \
  -e "OPENSEARCH_JAVA_OPTS=-Xms4g -Xmx4g" \
  opensearchproject/opensearch:3.3.2
```

Stop the container

```bash
docker stop opensearch-node
```

Save the data folder

```bash
tar cvfz opensearch_data.tgz ~/Workspace/docker-mount/opensearch
```

Copy to GCP instance

```bash
gcloud compute scp opensearch_data.tgz $GCP_INSTANCE_NAME:~/
```

On GCP instance, uncompress the data folder

```bash
tar xvfz opensearch_data.tgz
sudo chown -R 1000:1000 opensearch
```

Start a new container

```bash
docker run -d \
  --name opensearch-node \
  -v ~/opensearch:/usr/share/opensearch/data \
  -p 9200:9200 -p 9600:9600 \
  -e "discovery.type=single-node" \
  -e "DISABLE_SECURITY_PLUGIN=true" \
  -e "DISABLE_INSTALL_DEMO_CONFIG=true" \
  -e "OPENSEARCH_JAVA_OPTS=-Xms4g -Xmx4g" \
  -e "network.host=0.0.0.0" \
  opensearchproject/opensearch:3.3.2
```

Check the index

```bash
curl -XGET 'localhost:9200/_cat/indices?v'
```
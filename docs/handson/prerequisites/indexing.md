# OpenSearch

## Installation

See [https://hub.docker.com/r/opensearchproject/opensearch](https://hub.docker.com/r/opensearchproject/opensearch)

Preparation

- A local folder to store index files: `[path to local folder]`

Obtain a docker image

```bash
docker pull opensearchproject/opensearch:latest
# docker pull opensearchproject/opensearch:latest
# ...
```

Start a new container

- Note: `DISABLE_SECURITY_PLUGIN=true` option is for a local testing to skip the admin password, etc.

```bash
docker run -d -p 9200:9200 -p 9600:9600 \
    -v [path to local folder]:/usr/share/opensearch/data \
    -e "discovery.type=single-node" \
    -e "DISABLE_SECURITY_PLUGIN=true" \
    -e "DISABLE_INSTALL_DEMO_CONFIG=true" \
    -e "OPENSEARCH_JAVA_OPTS=-Xms4g -Xmx4g" \
    --name opensearch-node opensearchproject/opensearch:latest
```

Test a connection to OpenSearch server

```bash
curl http://localhost:9200
# {
#   "name" : "c626c8732069",
#   "cluster_name" : "docker-cluster",
#   "cluster_uuid" : "iuwnMQg9S7qBNtHVfmrvLw",
#   "version" : {
#     "distribution" : "opensearch",
#     "number" : "3.5.0",
#     "build_type" : "tar",
#     "build_hash" : "bbc94f0bdc3a759011e6529ecfe52840856f91a3",
#     "build_date" : "2026-02-07T07:54:31.169913465Z",
#     "build_snapshot" : false,
#     "lucene_version" : "10.3.2",
#     "minimum_wire_compatibility_version" : "2.19.0",
#     "minimum_index_compatibility_version" : "2.0.0"
#   },
#   "tagline" : "The OpenSearch Project: https://opensearch.org/"
# }
```

## Additional operations on docker container

See logs of the opensearch container

```bash
docker logs opensearch-node -f
# Ctrl+C to close
```

Stop the container

```bash
docker stop opensearch-node
```

Restart the container

```bash
docker start opensearch-node
```

Remove the container (be careful)

- Index files in `[path to local folder]` will not be deleted.

```bash
docker rm opensearch-node
```

## What's Next?

- Index a corpus for [BM25 Model](indexing_bm25.md)
- Index a corpus for [SPLADE Model](indexing_splade.md)
- Index a corpus for [DPR Model](indexing_dpr.md)
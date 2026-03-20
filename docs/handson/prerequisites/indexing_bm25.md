# BM25 Model

!!! quote "Notebook"
    - [indexing_bm25.ipynb](https://github.com/geniie-lab/chiir2026/blob/main/docs/handson/prerequisites/indexing_bm25.ipynb)

## Indexing

!!! success "Checking"
    Make sure you completed the steps in [Dataset](./dataset.md) and [Indexing/OpenSearch](indexing.md) first.


### Install python modules

```bash
(venv) python -m pip install ir_datasets pandas opensearch-py
```

### Load helper modules

```python
import pprint
from tqdm import tqdm
```

### Create an OpenSearch Client

```python
from opensearchpy import OpenSearch

host = 'localhost'
port = 9200

client = OpenSearch(
    hosts = [{'host': host, 'port': port}],
    http_compress = True,
    use_ssl = False,
    verify_certs = False,
    ssl_assert_hostname = False,
    ssl_show_warn = False
)
pprint.pprint(client.info())
# {'cluster_name': 'docker-cluster',
#  'cluster_uuid': 'iuwnMQg9S7qBNtHVfmrvLw',
#  ...
```

### Index a Corpus for BM25 Model

Note: Every corpus requires a different configuration for indexing.

- We use [beir/scidocs](https://ir-datasets.com/beir.html#beir/scidocs) as an example

```python
import ir_datasets
dataset_name = "beir/scidocs"
dataset = ir_datasets.load(dataset_name)
```

Index Structure

```python
index_name = "scidocs_bm25"
index_body = {
  "settings": {
    "index": {
      "number_of_shards": 1,
      "number_of_replicas": 0
    }
  },
  "mappings": {
    "properties": {
        "docid": { "type": "keyword" },
        "title": { "type": "text" },
        "text": { "type": "text" },
    }
  }
}
response = client.indices.create(index=index_name, body=index_body)
pprint.pprint(response)
# {'acknowledged': True, 'index': 'scidocs_bm25', 'shards_acknowledged': True}
```

Indexing

```python
for doc in tqdm(dataset.docs_iter(), desc="Indexing"):
    doc_body = {
        "docid": doc.doc_id,
        "title": doc.title,
        "text": doc.text
    }
    response = client.index(index=index_name, body=doc_body)
# Indexing: 25657it [01:09, 368.43it/s]
```


### Search Test

A quick search method

```python
def search(query: str, size: int = 10) -> dict:
    body = {
        "size": size,
        "query": {
            "multi_match": {
                "query": query,
                "fields": ["title^2", "text"] # title gets a boost
            }
        },
    }

    return client.search(index=index_name, body=body)
```

Search for a sample query

```python
q = "Ad Hoc Retrieval Experiments Using WordNet"
resp = search(q, size=5)

print(f"\nTop {len(resp['hits']['hits'])} hits for query: {q}\n")
for hit in resp["hits"]["hits"]:
    src = hit["_source"]
    print(f"[{src['docid']}] {src['title'][:50]}... (score={hit['_score']:.2f})")

# Top 5 hits for query: Ad Hoc Retrieval Experiments Using WordNet

# [0ef311acf523d4d0e2cc5f747a6508af2c89c5f7] LDA-based document models for ad-hoc retrieval... (score=18.32)
# [59407446503d49a8cf5f5643b17502835b62f139] Using WordNet to Disambiguate Word Senses for Text... (score=13.98)
# [25190bd8bc97c78626f5ca0b6f59cf0360c71b58] Mobile ad hoc networking: imperatives and challeng... (score=13.97)
# [006df3db364f2a6d7cc23f46d22cc63081dd70db] Dynamic source routing in ad hoc wireless networks... (score=13.35)
# [384f9e49644a16656cd2f46f3d8213bd2f3f0de3] Towards cloud based mobile ad hoc network simulati... (score=13.35)
```

## What's Next?

Move on to [LLMs](llms.md)!
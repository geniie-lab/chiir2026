# DPR Model

!!! quote "Notebook"
    - [indexing_dpr.ipynb](https://github.com/geniie-lab/chiir2026/blob/main/docs/handson/prerequisites/indexing_dpr.ipynb)

## Indexing

!!! success "Checking"
    Make sure you completed the steps in [Dataset](./dataset.md) and [Indexing/OpenSearch](indexing.md) first.

!!! tip "GPU Needed"
    You would want to use a GPU for this step.

!!! warning "Document truncation"
    The encoding model used here indexes the first N tokens of each document and ignore the rest. `N=512`

### Install python modules

```bash
(venv) python -m pip install ir_datasets opensearch-py sentence_transformers torch==2.9.1 torchvision --index-url https://download.pytorch.org/whl/cu130
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

### Index a Corpus for DPR Model

Note: Every corpus requires a different configuration for indexing.

- We use [beir/scidocs](https://ir-datasets.com/beir.html#beir/scidocs) as an example

```python
import ir_datasets
dataset_name = "beir/scidocs"
dataset = ir_datasets.load(dataset_name)
```

Index Structure

```python
index_body ={
  "settings": {
    "index": {
      "number_of_shards": 1,
      "number_of_replicas": 0,
      "knn": True
    }
  },
  "mappings": {
    "properties": {
      "docid": { "type": "keyword" },
      "title": { "type": "text" },
      "text": { "type": "text" },
      "dense_vector": {
        "type": "knn_vector",
        "dimension": 768, # from sentence-transformers/msmarco-bert-base-dot-v5
        "space_type": "innerproduct" # from sentence-transformers/msmarco-bert-base-dot-v5
      }
    }
  }
}
response = client.indices.create(index=index_name, body=index_body)
pprint.pprint(response)
# {'acknowledged': True, 'index': 'scidocs_dpr', 'shards_acknowledged': True}
```

Encoding Model

```python
import torch

device = 'cuda' if torch.cuda.is_available() else 'cpu'
print(f"Using device: {device}")
# Using device: cuda
```

```python
from sentence_transformers import SentenceTransformer
encoder_model  = "sentence-transformers/msmarco-bert-base-dot-v5"
model = SentenceTransformer(encoder_model).to(device)
# Loading weights: 100%|██████████| 199/199 [00:00<00:00, 2801.79it/s, Materializing param=pooler.dense.weight] 
# ...
```

Indexing

```python
for doc in tqdm(dataset.docs_iter(), desc="Indexing"):
    doc_body = {
        "docid": doc.doc_id,
        "title": doc.title,
        "text":  doc.text,
    }
    doc_tensor = model.encode_document([f"{doc.title}\n{doc.text}"])
    doc_vector = doc_tensor.tolist()
    doc_body["dense_vector"] = doc_vector[0]
    response = client.index(index=index_name, body=doc_body)
# Indexing: 25657it [06:15, 68.41it/s]
```


### Search Test

A quick search method

```python
def search(query: str, size: int = 10) -> dict:
    query_tensor = model.encode_query([query])
    query_vector = query_tensor.tolist()[0]
    query_body = {
        "size": size,
        "query": {
            "knn": {
                "dense_vector": {
                    "vector": query_vector,
                    "k": size
                }
            }
        }
    }
    return client.search(index=index_name, body=query_body)
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

# [0ef311acf523d4d0e2cc5f747a6508af2c89c5f7] LDA-based document models for ad-hoc retrieval... (score=171.17)
# [59407446503d49a8cf5f5643b17502835b62f139] Using WordNet to Disambiguate Word Senses for Text... (score=171.11)
# [cc06ad0ed7b91c93b64d10ee4ed700c33f0d9f13] Neural systems behind word and concept retrieval... (score=170.68)
# [62eff7763f8679d0afe53dad4d85279d54f763c5] Using WordNet as a Knowledge Base for Measuring Se... (score=170.40)
# [e9302c3fee03abb5dd6e134118207272c1dcf303] Neural embedding-based indices for semantic search... (score=169.74)
```

## What's Next?

Move on to [LLMs](llms.md)!
# SPLADE Model

!!! quote "Notebook"
    - [indexing_splade.ipynb](indexing_splade.ipynb)

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
 and [Indexing/OpenSearch](indexing.md) 
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

### Index a Corpus for SPLADE Model

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
      "number_of_replicas": 0
    }
  },
  "mappings": {
    "properties": {
      "docid": { "type": "keyword" },
      "title": { "type": "text" },
      "text": { "type": "text" },
      "sparse_embedding": {
        "type": "rank_features"
      }
    }
  }
}
response = client.indices.create(index=index_name, body=index_body)
pprint.pprint(response)
# {'acknowledged': True, 'index': 'scidocs_splade', 'shards_acknowledged': True}
```
Encoding Model

```python
import torch

device = 'cuda' if torch.cuda.is_available() else 'cpu'
print(f"Using device: {device}")
# Using device: cuda
```

```python
from sentence_transformers.sparse_encoder import SparseEncoder
encoder_model = "opensearch-project/opensearch-neural-sparse-encoding-doc-v3-distill"
model = SparseEncoder(encoder_model, trust_remote_code=True).to(device)
# Loading weights: 100%|██████████| 105/105 [00:00<00:00, 1528.10it/s, Materializing param=vocab_transform.weight]
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
    doc_embedding = model.decode(doc_tensor)
    doc_body["sparse_embedding"] = dict(doc_embedding[0])
    response = client.index(index=index_name, body=doc_body)
# Indexing: 25657it [05:44, 74.55it/s]
```


### Search Test

A quick search method

```python
def search(query: str, size: int = 10) -> dict:
    query_tensor = model.encode_query([query])
    query_embedding = model.decode(query_tensor)
    query_body = {
        "size": size,
        "query": {
            "neural_sparse": {
                "sparse_embedding": {
                    "query_tokens": dict(query_embedding[0])
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

# [59407446503d49a8cf5f5643b17502835b62f139] Using WordNet to Disambiguate Word Senses for Text... (score=13.89)
# [62eff7763f8679d0afe53dad4d85279d54f763c5] Using WordNet as a Knowledge Base for Measuring Se... (score=12.75)
# [1cc7013247056e45264de9817171d72690181692] A language modeling framework for resource selecti... (score=12.43)
# [c43826e860dfd9365aa8905397393d96513d1daa] Tapping into knowledge base for concept feedback: ... (score=11.09)
# [8b40b159c2316dbea297a301a9c561b1d9873c4a] Monolingual and Cross-Lingual Information Retrieva... (score=10.85)
```

## What's Next?

Move on to [LLMs](llms.md)!
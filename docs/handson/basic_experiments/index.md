# Basic Experiments

!!! tip "Start Small"

    - With geniie-lab, you can run many sessions easily, but starting small is a key for successful experiments.
    - Use a single topic (i.e., `max_topic=1`)
    - Use a small path (i.e., `path=["query"]` or `path=["query", "ranking"]`)
    - Use a small serp size (i.e., `serp_size=10`)

## Query Formulation

!!! example "Comparing AI Persona (System Prompt)"

    **Common Settings**

    ```python
    plan=["query"],
    max_topics=3,
    ```

    === "Experimental Settings"

        ```python
        models=[
            ModelDescription(
                type="openrouter",
                name="google/gemini-2.5-flash-lite",
                system_prompt="You're a helpful assistant",
                temperature=0.0,
            ),
            ModelDescription(
                type="openrouter",
                name="google/gemini-2.5-flash-lite",
                system_prompt="You're a helpful assistant in medical domain",
                temperature=0.0,
            )
        ],
        ```
    
    === "Sample Output"

        ```bash
        cat logs/expN.jsonl | jq '{ Model: .model, Query: .query }'
        ```

        ```json
        {
        "Model": "google/gemini-2.5-flash-lite",
        "Query": "economic dispatch problem valve-point effect direct search method"
        }
        ...
        {
        "Model": "google/gemini-2.5-flash-lite",
        "Query": "predicting defects SAP Java code experience report"
        }
        ---
        {
        "Model": "google/gemini-2.5-flash-lite",
        "Query": "economic dispatch problem valve-point effect direct search method"
        }
        ...
        {
        "Model": "google/gemini-2.5-flash-lite",
        "Query": "predicting defects SAP Java code"
        }
        ```


!!! example "Comparing Tool Descriptions"

    **Common Settings**

    ```python
    plan=["query"],
    max_topics=1,
    ```

    === "Experimental Settings"

        ```python
        tools=[
            ToolDescription(
                name="opensearch",
                ranking_model="bm25",
                index_name="scidocs_bm25",
                host="[Change here]",
                port=9200,
                use_ssl=False,
                description="It allows you to perform searches using only keywords and employs the BM25 ranking model to order results.",
            ),
            ToolDescription(
                name="opensearch",
                ranking_model="bm25",
                index_name="scidocs_bm25",
                host="[Change here]",
                port=9200,
                use_ssl=False,
                description="It allows you to perform searches using Lucene syntax and employs the BM25 ranking model to order results.",
            )
        ],
        ```
    
    === "Sample Output"

        ```bash
        cat logs/expN.jsonl | jq '{ Model: .model, Query: .query }'
        ```

        ```json
        {
        "Model": "openai/gpt-4o-mini",
        "Query": "Economic Dispatch Problem Valve-Point Effect"
        }
        ...
        {
        "Model": "openai/gpt-4o-mini",
        "Query": "Economic Dispatch Problem AND Valve-Point Effect"
        }
        ```

!!! example "Comparing LLMs"

    **Common Settings**

    ```python
    plan=["query"],
    max_topics=1,
    ```

    === "Experimental Settings"

        ```python
        models=[
            ModelDescription(
                type="openrouter",
                name="openai/gpt-4o-mini",
                system_prompt="You're a helpful assistant",
                temperature=0.0,
            ),
            ModelDescription(
                type="openrouter",
                name="google/gemini-2.5-flash-lite",
                system_prompt="You're a helpful assistant",
                temperature=0.0,
            )
        ],
        ```
    
    === "Sample Output"

        ```bash
        cat logs/expN.jsonl | jq '{ Model: .model, Query: .query }'
        ```

        ```json
        {
            "Model": "openai/gpt-4o-mini",
            "Query": "Economic Dispatch Problem Valve-Point Effect"
        }
        ...
        {
            "Model": "google/gemini-2.5-flash-lite",
            "Query": "economic dispatch problem valve-point effect direct search method"
        }
        ```

## Ranking

!!! example "Comparing ranking models"

    **Common Settings**

    ```python
    plan=["query", "ranking"],
    max_topics=1,
    ```

    === "Experimental Settings"

        ```python
        models=[
            ModelDescription(
                type="openrouter",
                name="openai/gpt-4o-mini",
                system_prompt="You're a helpful assistant",
                temperature=0.0,
            )
        ],
        tools=[
            ToolDescription(
                name="opensearch",
                ranking_model="bm25",
                index_name="scidocs_bm25",
                host="[Change here]",
                port=9200,
                use_ssl=False,
                description="It allows you to perform searches using only keywords and employs the BM25 ranking model to order results.",
            ),
            ToolDescription(
                name="opensearch",
                ranking_model="splade",
                encode_model="opensearch-project/opensearch-neural-sparse-encoding-doc-v3-distill",
                index_name="scidocs_splade",
                host="[Change here]",
                port=9200,
                use_ssl=False,
                description="It allows you to perform searches using only keywords and employs the SPLADE ranking model to order results.",
            )
        ],
        ```
    
    === "Sample Output"

        ```bash
        cat logs/expN.jsonl | jq '{ Model: .model, Ranker: .ranker, Performance: .performance }'
        ```

        ```json
        {
            "Model": "openai/gpt-4o-mini",
            "Ranker": "bm25",
            "Performance": {
                "RR@10": 0.2,
                "nDCG@10": 0.13120507751234178
            }
        }
        ...
        {
            "Model": "openai/gpt-4o-mini",
            "Ranker": "splade",
            "Performance": {
                "RR@10": 0.125,
                "nDCG@10": 0.10699313236726378
            }
        }
        ```


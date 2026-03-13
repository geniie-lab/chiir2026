---
hide:
    - toc
---

# First Experiment

!!! info "Colab Terminal"

    The following instructions should be executed from either 1) Terminal in Google Colab or 2) the terminal in VSCode which is connected to Colab Server.

    Let's go to `geniie-lab` folder first
    
    ```bash
    /content#
    /content# cd /content/drive/MyDrive/geniie-lab
    /content/drive/MyDrive/geniie-lab#
    ```

!!! example "Run the session experiment script"

    ```bash
    python scripts/run_session_experiment_chiir2026.py > logs/exp1.jsonl 2> logs/exp1.log
    # 2026-02-25 11:33:38,555 - INFO - NumExpr defaulting to 2 threads.
    # ...
    ```

!!! question "Got an error?"

    Don't worry! We're here to help :heart:

!!! abstract "Let's see the output!"

    - If the script completed without any error, type the following command in the terminal

        ```bash
        cat logs/exp1.jsonl | jq
        ```

    -  You should see something like this.

        ```json
        {
        "session_name": "my_session_experiment_at_chiir2026",
        "model": "openai/gpt-4o-mini",
        "task": "High-Precision Retrieval",
        "dataset": "beir/scidocs",
        "topic_id": "78495383450e02c5fe817e408726134b3084905d",
        "query": "Economic Dispatch Problem Valve-Point Effect",
        "start": 0,
        "size": 10,
        "repetition": 1,
        "reason": null,
        "stage": "query",
        "created_at": "2026-02-25T11:35:01.548089+00:00"
        }
        ```
    
    - Log is available in `logs/exp1.log`

!!! success "Congratulations :tada:"

    You successfully ran the first experiment using geniie-lab!

    What just happened? Well, you instructed the language model `gpt-4o-mini` to formulate a query based on the context information about ...

    - Precision-oriented retrieval task;
    - Corpus and first topic of `beir/scidocs` dataset; and
    - BM25 ranking model

!!! tip "A quick exercise"

    - Edit `scripts/run_session_experiment_chiir2026.py` (Around Line 106)

        ```python
        full_log=False # Change this to full_log=True
        ```
    
    - Save it and run the script again
    - See `logs/exp1.log` for detail transactions with LLMs
    - :bulb: Don't forget to put it back to `False` for the rest of the tutorial (unless you're interested).
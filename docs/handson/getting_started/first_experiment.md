---
hide:
    - toc
---

# First Experiment

!!! info "Colab Terminal in VSCode"

    The following instructions should be executed from the terminal in VSCode which is connected to Colab Server.

    You should see the following prompt in the terminal.

    ```bash
    /content/drive/MyDrive/geniie-lab#
    ```

!!! example "Run the session experiment script"

    ```bash
    python scripts/run_session_experiment_chiir2026.py > logs/first_exp.jsonl 2> logs/first_exp.log
    # 2026-02-25 11:33:38,555 - INFO - NumExpr defaulting to 2 threads.
    # ...
    ```

!!! question "Got an error?"

    Don't worry! We're here to help :heart:

!!! tip "Let's see the output!"

    - If the script completed without any error, type the following command in the terminal

        ```bash
        cat logs/first_exp.jsonl | jq
        ```

    -  You should get something like this.

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
    
    - Log is available from `logs/first_exp.log`

!!! success "Congratulations :tada:"

    You successfully ran the first experiment using geniie-lab!
---
hide:
    - toc
---

# Setup geniie-lab

!!! success "Check List"

    - [x] VSCode has been installed
    - [x] Google Colab Extension has been installed
    - [x] VSCode has connected to Colab Server
    - [x] VScode has mounted Google Drive and you can see a list of files
    - [x] You know how to start a Colab terminal in VSCode

    :bulb: Not yet? Don't worry. Follow the instruction in [How to prepare your PC for the hands-on session](../howto_prepare/index.md)

!!! info "Colab Terminal in VSCode"

    The following instructions should be executed from the terminal in VSCode which is connected to Colab Server.

    You should see a prompt like this in the terminal.

    ```bash
    /content#
    ```

!!! note ":one: Clone geniie-lab dev repository to your Google Drive"

    ```bash
    cd drive/MyDrive # or other location
    git clone https://github.com/geniie-lab/geniie-lab.git -b dev
    ```

    - This should create a folder called `geniie-lab` in your Google Drive.
    - Click `Colab` icon in Activitity Bar
    - Refresh the file list and find the folder

    ```
    Colab CPU (GPU T4)
      ├ drive
          ├ MyDrive
              ├ geniie-lab
    ```

!!! note ":two: Setup geniie-lab"

    :bulb: You need to do this everytime you make a new connection to the server.

    ```bash
    cd geniie-lab
    python -m pip install -r requirements_colab.txt
    # Collecting ...
    python -m pip install -e .
    # Obtaining file:///content/drive/MyDrive/geniie-lab
    # ...
    ```

!!! note ":three: Add .env file"

    - Right-click the `geniie-lab` folder in the list :arrow_right: `New File...`
    - Enter `.env` as the file name
    - Copy and paste a KEY sent from the organiser

        ```
        OPENROUTER_API_KEY="..."
        ```

    - Save the file

!!! note ":four: Change the host for OpenSearch"

    - Find `scripts/run_session_experiment_chiir2026.py`

        ```
        Colab CPU (GPU T4)
        ├ drive
            ├ MyDrive
                ├ geniie-lab
                    ├ scripts
                        ├ run_session_experiment_chiir2026.py
        ```

    - Open the file and change the `localhsot` to an IP Address shared by the organiser
        - Around Line 58

        ```python
        tools=[
            ToolDescription(
                name="opensearch",
                ranking_model="bm25",
                index_name="scidocs_bm25",
                host="localhost",             # <--- CHANGE HERE
                port=9200,
                use_ssl=False,
                description="It allows you to perform searches using keywords only and employs the BM25 ranking model to order results.",
            )
        ],
        ```

??? tip "We're good to go!"
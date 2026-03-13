# How to prepare your PC for the hands-on session

!!! tip "Choose your method"

    - Method 1: Easy to get started. Editing might be slightly cumbersome.
    - Method 2: Need extra time to get started. Editing should be more comfortable.

## Method 1: Google Colab (Browser) Only

!!! success "What you need to have"

    - Google Account


## Method 2: VSCode + Google Colab

!!! example "VSCode + Google Colab"

    - This method will use a virtual machine of Google Colab.
    - We will then use VSCode to talk to Google Colab.
    - See [https://developers.googleblog.com/google-colab-is-coming-to-vs-code/](https://developers.googleblog.com/google-colab-is-coming-to-vs-code/)

!!! success "What you need to have"

    - Google Account
    - [VSCode](https://code.visualstudio.com/Download) installed on your PC

!!! abstract "Install Colab Extension in VSCode"

    See [https://developers.googleblog.com/google-colab-is-coming-to-vs-code/](https://developers.googleblog.com/google-colab-is-coming-to-vs-code/#getting-started-with-the-colab-extension)

    - Click :material-view-grid-plus: `Extension Icon` on the [Activity Bar](https://code.visualstudio.com/docs/getstarted/userinterface) of VSCode
    - Type `Colab` in the search box
    - Select :simple-googlecolab: `Colab` extension by Google :arrow_right: Install
        - Avoid similar extensions by other vendors.
    - Type `Ctrl+,` to open the Settings
        - Or, click :wheel: `Wheel Icon` on the Activity Bar :arrow_right: Settings
    - Type `Colab` in the search box
    - Check all boxes for the experimental features of Colab Extension
        - [x] Colab: Activity Bar
        - [x] Colab: Server Mounting
        - [x] Colab: Terminal
        - [x] Colab: Uploading

!!! abstract "Connect to Google Colab"

    - Download [Welcome notebook](https://github.com/geniie-lab/chiir2026/blob/dev-handson/docs/handson/howto_prepare/welcome.ipynb) to your PC
    - Open the notebook **using VSCode**
    - Follow the instruction in the notebook

!!! question "When you lost a connection to Colab Server"

    - Close VSCode and restart it
    - Open the Welcome notebook and repeat the connection steps
    - Repeat the step 2 of [Set up geniie-lab](../getting_started/setup_geniielab.md)
# LLMs

## Background

!!! question "Model Selection: Model Types and Access Methods"

    We need to consider two aspects for model selection in search behaviour analysis.

    - Model Types
        - Proprietary Models: This includes Open AI's GPT models, Google's Gemini models, etc. Often more capable and faster.
        - Open-Weight Models: This includes Meta's Llama models, Alibaba's Qwen models, etc. Essential for reproducible experiments.
    - Access Methods
        - Remote Access: Talk to LLMs via official APIs and other commerical APIs (e.g., openrouter, groq). Usually requires a subscription. Some services allow you to access both proprietary and open-weight models.
        - Local Access: Talk to LLMs via tools such as `Ollama` and `vLLM`. Requires a descent hardware (GPU) to host large models, but can avoid data leakage of private/copyrighted contents.

!!! example "Parameter Size and Structured Output"

    - Most LLMs disclose their parameter size.
        - `gpt-oss-20b` has approx. 20 billion parameters.
        - `llama3.3-70b` has approx. 70 billion parameters.
    - Model search behaviour experiments require LLM's `structured output` capability
        - Capability to generate the output in, say, JSON format
    - However, LLMs with small parameter size (e.g., less than 20-30b) are prone to JSON format errors.
        - Consider using a larger model when you frequently experience output errors.


## Remote Access

!!! tip "Subscription Needed"
    Make an account and buy credits. Then, issue an API key.

- OpenAI: [https://openai.com/api/](https://openai.com/api/)
- Google: [https://ai.google.dev/gemini-api/](https://ai.google.dev/gemini-api/)
- OpenRouter: [https://openrouter.ai/](https://openrouter.ai/)
- Groq: [https://groq.com/](https://groq.com/)
- Many more ...

## Local Access

!!! tip "GPU Needed"
    You will definately need a descent GPU to access local models. See [this page](https://www.databasemart.com/blog/choosing-the-right-gpu-for-popluar-llms-on-ollama) for some guidance.

### Ollama

!!! question "Compare to vLLM"
    This will be easier to successfully deploy a model yet responses will be slower.

Model: `llama3.3:70b-instruct-q4_K_M`

```bash
docker run -d \
  --runtime nvidia \
  --gpus all \
  --name ollama \
  -p 11343:11343 \
  -v ~/.ollama:/root/.ollama \
  ollama/ollama:latest
```

```bash
docker exec -it ollama pull llama3.3:70b-instruct-q4_K_M
```

Connection Test

```bash
curl http://localhost:11434/v1/chat/completions \
    -H "Content-Type: application/json" \
    -d '{
        "model": "llama3.3:70b-instruct-q4_K_M",
        "messages": [
            {"role": "system", "content": "You are a helpful assistant."},
            {"role": "user", "content": "Who won the world series in 2020?"}
        ]
    }' | jq
```

### vLLM

!!! question "Compare to Ollama"
    This might be harder to successfully deploy a model yet responses will be faster.

Model: `nvidia/Llama-3.3-70B-Instruct-NVFP4`

```bash
docker run -d \
  --runtime nvidia \
  --gpus all \
  --name vllm-llama3.3-70b \
  -p 8000:8000 \
  -v ~/.cache/huggingface:/root/.cache/huggingface \
  nvcr.io/nvidia/vllm:26.01-py3 vllm serve \
  --model nvidia/Llama-3.3-70B-Instruct-NVFP4 \
  --no-enable-prefix-caching \
  --gpu-memory-utilization 0.75
```

Connection Test

```bash
curl http://localhost:8000/v1/chat/completions \
    -H "Content-Type: application/json" \
    -d '{
        "model": "nvidia/Llama-3.3-70B-Instruct-NVFP4",
        "messages": [
            {"role": "system", "content": "You are a helpful assistant."},
            {"role": "user", "content": "Who won the world series in 2020?"}
        ]
    }' | jq
```
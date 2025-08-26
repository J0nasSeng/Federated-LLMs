FROM nvcr.io/nvidia/pytorch:25.08-py3

COPY . /app/
WORKDIR /app

RUN apt-get update && apt-get install -y \
    iperf \
    curl \
    wget \
    git \
    tmux \
    && rm -rf /var/lib/apt/lists/*


RUN pip install -r requirements.txt

ARG HF_TOKEN
RUN huggingface-cli login --token $HF_TOKEN

# docker build --build-arg HF_TOKEN=your_token_here -t fedllm .

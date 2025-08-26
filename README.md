# Federated-LLMs

In this repository we collect models, datasets and other resources that can be used for federated LLM training using [torchtitan](https://github.com/pytorch/torchtitan/tree/main) and [torchft](https://github.com/pytorch/torchft). Here, we specifically use the DiLoco algorithm for federated training of LLM architectures.

## Setup
To get started, first build the docker container by running

```
docker build --build-arg HF_TOKEN=your_token_here -t fedllm . 
```

Then, you simply run the container (for demonstration purposes we do it in interactive mode):

```
docker run -v [HOST_PATH]:/app/ -it --gpus all fedllm 
```

Once the container is running, you have to start a lighthouse server. This server coordinates the DiLoco training and comes from `torchft`.

```
RUST_BACKTRACE=1 torchft_lighthouse --min_replicas 1 --quorum_tick_ms 100 --join_timeout_ms 10000
```

If the server is running, you can start a new shell and run the following command to start a worker:

```
NGPU=2 CUDA_VISIBLE_DEVICES=1,2 CONFIG_FILE="./src/models/llama3/configs/debug_config.toml" bash ./run_train.sh --fault_tolerance.enable --fault_tolerance.replica_id=0 --fault_tolerance.group_size=2 --parallelism.data_parallel_shard_degree=2
```

> Note that for each worker, you have to start a separate shell.
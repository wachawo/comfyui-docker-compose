# ComfyUI (Docker + NVIDIA GPU)

Dockerized [ComfyUI](https://github.com/comfyanonymous/ComfyUI) based on `nvidia/cuda:13.0.3-cudnn-runtime-ubuntu24.04` with PyTorch cu130.

## Requirements

- Linux with NVIDIA driver (check with `nvidia-smi`)
- Docker + Docker Compose
- [nvidia-container-toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html) for GPU passthrough

## Run

```bash
cp .env.example .env   # if present; otherwise use your existing .env
docker compose up -d --build
```

Two build targets are shipped:

| Dockerfile          | Base                                | PyTorch | Host driver reports |
|---------------------|-------------------------------------|---------|---------------------|
| `Dockerfile`        | `nvidia/cuda:13.0.3-…` *(default)*  | cu130   | CUDA ≥ 13.0         |
| `Dockerfile.cu128`  | `nvidia/cuda:12.8.1-…`              | cu128   | CUDA 12.8 / 12.9    |

Check your driver with `nvidia-smi` (top-right corner). Switch by setting in `.env`:

```env
DOCKERFILE=Dockerfile.cu128
COMFYUI_IMAGE=comfyui_gpu_cu128
```

Then rebuild: `docker compose build --no-cache && docker compose up -d`.

The UI is available at `http://localhost:8188`.

Logs:

```bash
docker compose logs -f comfyui
```

Stop:

```bash
docker compose down
```

## Configuration

Variables in `.env`:

| Variable            | Default          | Description                                           |
|---------------------|------------------|-------------------------------------------------------|
| `TZ`                | `America/New_York` | Container timezone                                  |
| `COMFYUI_HOST`      | `0.0.0.0`        | Listen address                                        |
| `COMFYUI_PORT`      | `8188`           | ComfyUI port                                          |
| `COMFYUI_EXTRA_ARGS`| `""`             | Extra `main.py` flags (`--lowvram`, `--novram`, `--cpu`) |
| `CIVITAI_TOKEN`     | `""`             | [Civitai API key](https://civitai.com/user/account) for model downloads |
| `HF_TOKEN`          | `""`             | [HuggingFace token](https://huggingface.co/settings/tokens); also exported as `HUGGING_FACE_HUB_TOKEN` |
| `HF_HUB_OFFLINE`    | `0`              | `1` disables HF network (use only cached models)      |
| `HUGGINGFACE_HUB_CACHE` | `/opt/ComfyUI/cache` | HF cache dir inside container (mounted from `./cache`) |

## Volumes

Host directories are mounted into the container (created automatically):

| Host            | Container                   | Purpose                       |
|-----------------|-----------------------------|-------------------------------|
| `./models`      | `/opt/ComfyUI/models`       | Checkpoints, LoRA, VAE, etc.  |
| `./custom_nodes`| `/opt/ComfyUI/custom_nodes` | Custom nodes                   |
| `./input`       | `/opt/ComfyUI/input`        | Input images                   |
| `./output`      | `/opt/ComfyUI/output`       | Generation outputs             |
| `./user`        | `/opt/ComfyUI/user`         | User workflows                 |
| `./logs`        | `/opt/ComfyUI/logs`         | Logs                           |

## Install Without Docker

See [INSTALL.md](INSTALL.md).

# Installing ComfyUI on Ubuntu 24.04 with NVIDIA GPU

## 1. Check the NVIDIA Driver

```bash
nvidia-smi
```

If the command does not work, install the driver:

```bash
sudo ubuntu-drivers autoinstall
sudo reboot
```

After rebooting, run `nvidia-smi` again and note the CUDA version shown in the top-right corner of the output.

## 2. Install System Dependencies

Ubuntu 24.04 ships with Python 3.12, which is exactly what ComfyUI needs.

```bash
sudo apt update
sudo apt install -y python3 python3-pip python3-venv git
```

Check the version:

```bash
python3 --version   # expected: 3.12.x
```

## 3. Create a Workspace Directory and venv

```bash
mkdir -p ~/comfyui-workspace
cd ~/comfyui-workspace
python3 -m venv comfy-env
source comfy-env/bin/activate
```

You need to activate the venv each time before launching ComfyUI. Exit with `deactivate`.

## 4. Install Comfy CLI

```bash
pip install --upgrade pip
pip install comfy-cli
comfy --install-completion   # shell completion (optional)
```

## 5. Install ComfyUI

```bash
comfy install
```

By default, ComfyUI is installed to `~/comfy`. Check the path:

```bash
comfy which
```

To install in the current directory, use `comfy --workspace=$(pwd) install`.

## 6. Install CUDA-enabled PyTorch

First, remove the CPU build that may have been installed as a dependency:

```bash
pip uninstall -y torch torchvision torchaudio
```

Then install a CUDA build (see pytorch.org for the latest index URL; example for CUDA 12.4):

```bash
pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu124
```

Verify that the GPU is visible:

```bash
python3 -c "import torch; print(torch.cuda.is_available(), torch.version.cuda, torch.cuda.get_device_name(0))"
```

Expected output: `True <cuda_version> <gpu_name>`.

## 7. Launch

```bash
comfy launch
```

By default, it listens on `http://localhost:8188`.

Useful flags:

```bash
comfy launch -- --listen 0.0.0.0 --port 8080   # network access
comfy launch -- --lowvram                      # low VRAM
comfy launch -- --novram                       # very low VRAM
```

## 8. Quick Start Script (Optional)

Create `~/comfyui-workspace/start-comfy.sh`:

```bash
#!/bin/bash
cd ~/comfyui-workspace
source comfy-env/bin/activate
comfy launch -- --listen 0.0.0.0 --port 8188
```

```bash
chmod +x ~/comfyui-workspace/start-comfy.sh
```

## 9. Models

Put base checkpoints in `~/comfy/models/checkpoints/` (confirm path via `comfy which`). Example download:

```bash
comfy model download \
  --url https://huggingface.co/runwayml/stable-diffusion-v1-5/resolve/main/v1-5-pruned.safetensors \
  --relative-path models/checkpoints
```
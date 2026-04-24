# GPU image based on CUDA 13.0 + cuDNN (Ubuntu 24.04 ships Python 3.12).
FROM nvidia/cuda:13.0.3-cudnn-runtime-ubuntu24.04

ENV DEBIAN_FRONTEND=noninteractive \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1

# System dependencies per INSTALL.md step 2 plus runtime libs required by
# ComfyUI nodes (ffmpeg for video, libgl1/libglib2.0-0 for OpenCV, libsndfile1
# for soundfile). libcublas-13-0 provides cuBLAS / cuBLASLt runtime that
# torch cu130 calls into — the `-runtime` base image does not include it,
# without it the first matmul on CUDA fails with `CUBLAS_STATUS_NOT_INITIALIZED`.
RUN apt-get update && apt-get install -y --no-install-recommends \
        python3 \
        python3-pip \
        python3-venv \
        git \
        ca-certificates \
        ffmpeg \
        build-essential \
        libgl1 \
        libglib2.0-0 \
        libsndfile1 \
        libcublas-13-0 \
    && rm -rf /var/lib/apt/lists/*

# Virtualenv per INSTALL.md step 3 — venv on PATH means plain `pip`/`python3`
# target it without explicit activation.
ENV PATH="/opt/venv/bin:${PATH}"
RUN python3 -m venv /opt/venv \
 && pip install --no-cache-dir --upgrade pip

# ComfyUI checkout (INSTALL.md step 5, adapted for Docker — comfy-cli is
# interactive-first and unreliable in non-TTY build context).
RUN git clone --depth=1 https://github.com/comfyanonymous/ComfyUI.git /opt/ComfyUI

WORKDIR /opt/ComfyUI

# PyTorch with CUDA 13.0 (INSTALL.md step 6, updated from cu124 to cu130).
RUN pip install --no-cache-dir \
        --extra-index-url https://download.pytorch.org/whl/cu130 \
        torch==2.10.0+cu130 torchvision torchaudio==2.10.0+cu130

RUN pip install --no-cache-dir -r requirements.txt

EXPOSE 8188

CMD ["python3", "main.py", "--listen", "0.0.0.0", "--port", "8188"]
#!/bin/bash

set -e  # Exit on error

# Create and activate virtual environment
python3 -m venv venv
source venv/bin/activate

# Get CUDA version
CUDA_RAW=$(nvidia-smi --version | grep "CUDA Version" | awk '{print $4}')
CUDA_NUM=$(echo "$CUDA_RAW" | sed 's/\.//g')  # e.g., 12.4 -> 124

echo "Detected CUDA version: $CUDA_RAW"

# Install PyTorch with correct CUDA version
echo "Installing PyTorch for cu$CUDA_NUM..."
pip install torch --index-url "https://download.pytorch.org/whl/cu$CUDA_NUM"

# Install from requirements.txt if it exists
echo "Installing requirements.txt..."
pip install -r requirements.txt

# Register kernel with Jupyter
KERNEL_NAME="myvenv"
DISPLAY_NAME="Python ($KERNEL_NAME)"
echo "Registering Jupyter kernel: $DISPLAY_NAME"
python -m ipykernel install --user --name="$KERNEL_NAME" --display-name="$DISPLAY_NAME"

echo "Setup complete"

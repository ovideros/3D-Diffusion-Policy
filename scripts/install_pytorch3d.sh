#!/bin/bash

# Activate conda environment if it exists
if [ -n "${CONDA_DEFAULT_ENV}" ]; then
    echo "Using conda environment: ${CONDA_DEFAULT_ENV}"
else
    echo "No conda environment activated. Please activate your environment first."
    exit 1
fi

# Remove existing PyTorch3D installation if any
pip uninstall -y pytorch3d

# Install dependencies
pip install 'fvcore>=0.1.5'
pip install 'iopath>=0.1.7'

# Compile pytorch3d_simplified with CUDA support
cd third_party/pytorch3d_simplified

# Clean any previous builds
rm -rf build/
rm -rf dist/
rm -rf *.egg-info/

# Set environment variables for CUDA build
export FORCE_CUDA=1
export TORCH_CUDA_ARCH_LIST="3.5;5.0;6.0;6.1;7.0;7.5;8.0;8.6+PTX"

# Install using traditional setup.py
python setup.py develop

cd ../.. 
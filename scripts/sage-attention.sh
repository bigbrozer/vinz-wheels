#!/bin/bash
# =============================================================================
# This script automates the installation and packaging of the SageAttention
# library, a machine learning attention mechanism implementation. It clones the
# SageAttention repository, installs dependencies, builds a wheel package, and
# copies the resulting wheel file to the wheels/ directory for distribution.
# =============================================================================

set -eu

# shellcheck disable=SC1091
source .venv/bin/activate

git clone https://github.com/thu-ml/SageAttention.git
pushd SageAttention/
python setup.py bdist_wheel
popd
cp -v SageAttention/dist/*.whl wheels

#!/bin/bash
# =============================================================================
# This script automates the installation and packaging of the SageAttention
# library, a machine learning attention mechanism implementation. It clones the
# SageAttention repository, installs dependencies, builds a wheel package, and
# copies the resulting wheel file to the wheels/ directory for distribution.
# =============================================================================

set -eu

BUILD_INFO="${BUILD_INFO:?error: BUILD_INFO environment variable is not set}"

# shellcheck disable=SC1091
source .venv/bin/activate

git clone https://github.com/thu-ml/SageAttention.git
pushd SageAttention/
python setup.py bdist_wheel
popd

if [[ -n "${BUILD_INFO}" ]]; then
  for whl in SageAttention/dist/*.whl; do
    dir=$(dirname "$whl")
    base=$(basename "$whl")
    # Insert +BUILD_INFO after the version: name-version-... → name-version+BUILD_INFO-...
    suffix="${base#*-*-}"
    prefix="${base%-"${suffix}"}"
    newbase="${prefix}+${BUILD_INFO}-${suffix}"
    mv "$whl" "${dir}/${newbase}"
  done
fi

cp -v SageAttention/dist/*.whl wheels

#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PKG_DIR="$ROOT_DIR/packages/python"

if [[ -z "${PYPI_API_TOKEN:-}" ]]; then
  echo "PYPI_API_TOKEN is required" >&2
  exit 1
fi

cd "$PKG_DIR"
rm -rf dist build *.egg-info src/*.egg-info

python -m pip install --upgrade build twine
python -m build
python -m twine upload --username __token__ --password "$PYPI_API_TOKEN" dist/*

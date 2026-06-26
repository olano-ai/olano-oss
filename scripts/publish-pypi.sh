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

PYTHON_BIN="${PYTHON_BIN:-python}"
if ! "$PYTHON_BIN" -m pip --version >/dev/null 2>&1; then
  if command -v python3 >/dev/null 2>&1 && python3 -m pip --version >/dev/null 2>&1; then
    PYTHON_BIN="python3"
  elif [[ -x /usr/bin/python3 ]]; then
    VENV_DIR="$ROOT_DIR/.publish-venv"
    /usr/bin/python3 -m venv "$VENV_DIR"
    PYTHON_BIN="$VENV_DIR/bin/python"
  else
    echo "No Python executable with pip available. Set PYTHON_BIN to a Python with pip." >&2
    exit 1
  fi
fi

"$PYTHON_BIN" -m pip install --upgrade build twine
"$PYTHON_BIN" -m build
"$PYTHON_BIN" -m twine upload --username __token__ --password "$PYPI_API_TOKEN" dist/*

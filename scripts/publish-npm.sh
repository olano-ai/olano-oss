#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PKG_DIR="$ROOT_DIR/packages/npm"

if [[ -z "${NPM_TOKEN:-}" ]]; then
  echo "NPM_TOKEN is required" >&2
  exit 1
fi

cd "$PKG_DIR"

# Write token to a local project npmrc only. Do not commit this file.
printf "//registry.npmjs.org/:_authToken=%s
" "$NPM_TOKEN" > .npmrc
trap 'rm -f "$PKG_DIR/.npmrc"' EXIT

npm publish --access public

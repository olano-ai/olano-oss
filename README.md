# olano-oss

Public open-source package placeholder repository for Olano.

This repository is reserved for publishing packages to:

- **npmjs** — JavaScript/TypeScript package placeholder in `packages/npm/`
- **PyPI** — Python package placeholder in `packages/python/`

The package implementations will be added as the public API stabilizes.

## Layout

```text
packages/
  npm/      # npm package placeholder
  python/   # PyPI package placeholder
```

## Status

Placeholder only. Do not use in production yet.

## Publishing

The repository includes publish scripts for reserving the package names on npm and PyPI as `olano`.

Required environment variables:

- `NPM_TOKEN`
- `PYPI_API_TOKEN`

Commands:

```bash
scripts/publish-npm.sh
scripts/publish-pypi.sh
scripts/publish-all.sh
```

The scripts read tokens from environment variables only. They do not store credentials in the repository.

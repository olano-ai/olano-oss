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

See **[RELEASING.md](RELEASING.md)** for the full release process — prerequisites, versioning,
verification, and troubleshooting. Quick reference below.

The publish scripts read tokens from environment variables only — they never store credentials
in the repository.

### npm — `@olano/olano` (published)

Live at https://www.npmjs.com/package/@olano/olano, published under the `@olano` org.

```bash
export NPM_TOKEN="npm_..."   # token with publish rights in the @olano org
scripts/publish-npm.sh       # runs: npm publish --access public
```

Note: the unscoped name `olano` is rejected by npm as too similar to the existing package
`nano`, so the package is published scoped under the `@olano` org. (An earlier unscoped build
is also published as `olano-ai` under the maintainer's npm account.) To publish a new release,
bump `version` in `packages/npm/package.json` first (a version that already exists cannot be
republished).

### PyPI — `olano`

Run from a machine with normal outbound network access — uploads go to `upload.pypi.org`, which
must be reachable (some sandboxed/CI networks allow installing from PyPI but block uploads):

```bash
# Use an ACCOUNT-scoped PyPI API token. A project-scoped token cannot create a
# brand-new project, so the first publish of `olano` needs an account-wide
# token (or a configured Trusted Publisher).
export PYPI_API_TOKEN="pypi-..."

scripts/publish-pypi.sh      # builds, runs `twine check`, then uploads
```

Requirements: Python 3.9+ (the script provisions an isolated venv for `build`/`twine` if needed).
The distribution installs and imports as `olano` (`pip install olano`, `import olano`).

### Both

```bash
scripts/publish-all.sh       # npm first, then PyPI
```

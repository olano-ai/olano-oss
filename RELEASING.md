# Releasing

This repository publishes two placeholder packages:

| Registry | Package | Install | Source |
|----------|---------|---------|--------|
| npm | [`@olano/olano`](https://www.npmjs.com/package/@olano/olano) | `npm install @olano/olano` | `packages/npm/` |
| PyPI | `olano` | `pip install olano` | `packages/python/` |

Both are currently at version `0.0.0`. The npm package is published; the PyPI
package is published manually from a machine that can reach `upload.pypi.org`
(see [PyPI](#release-to-pypi--olano) below).

Publish scripts live in [`scripts/`](scripts/) and read credentials from
environment variables only — **never commit tokens**. Each script writes any
temporary credential file (e.g. `.npmrc`) locally and removes it on exit.

## Prerequisites

**npm**
- Node 18+ and npm.
- An `NPM_TOKEN` with publish rights in the `@olano` org. Confirm membership:
  ```bash
  npm org ls olano        # you should be listed (owner/admin/member)
  ```
- The token must be an **Automation** or **Granular** token with read/write to
  the `@olano` org (a read-only token authenticates but cannot publish).

**PyPI**
- Python 3.9+.
- An **account-scoped** `PYPI_API_TOKEN`. A *project-scoped* token cannot create
  a brand-new project, so the first release of `olano` requires an account-wide
  token (or a configured [Trusted Publisher](https://docs.pypi.org/trusted-publishers/)).
- Network egress to `upload.pypi.org`. Some CI/sandbox networks allow installing
  *from* PyPI but block uploads — publish from a network that allows it.

## Versioning

A version that already exists on a registry **cannot be re-published** (npm and
PyPI both reject duplicate versions). Always bump before publishing, in both
manifests:

- npm: `packages/npm/package.json` → `"version"`
- PyPI: `packages/python/pyproject.toml` → `version`

Keep the two versions in sync.

## Release to npm — `@olano/olano`

```bash
export NPM_TOKEN="npm_..."        # publish rights in the @olano org
scripts/publish-npm.sh            # runs: npm publish --access public
```

Notes:
- Scoped packages are private by default; the script passes `--access public`.
- The unscoped name `olano` is **rejected by npm** as too similar to the existing
  `nano` package, which is why this package is scoped under `@olano`.

Verify:

```bash
npm view @olano/olano version
```

## Release to PyPI — `olano`

Run from a machine/network that can reach `upload.pypi.org`:

```bash
export PYPI_API_TOKEN="pypi-..."  # ACCOUNT-scoped token
scripts/publish-pypi.sh           # builds sdist + wheel, runs `twine check`, uploads
```

The script provisions an isolated virtualenv for `build`/`twine` if the active
Python lacks them. The distribution installs and imports as `olano`.

Verify:

```bash
curl -s https://pypi.org/pypi/olano/json | python3 -c "import sys,json;print(json.load(sys.stdin)['info']['version'])"
```

## Release both

```bash
export NPM_TOKEN="npm_..."
export PYPI_API_TOKEN="pypi-..."
scripts/publish-all.sh            # npm first, then PyPI
```

## Troubleshooting

| Symptom | Cause / fix |
|---------|-------------|
| npm `403 "You may not perform that action with these credentials"` | Token lacks publish rights or `@olano` org membership. Use an Automation/Granular token with read-write to the org. |
| npm `403 "Package name too similar to ..."` | npm's typosquat guard (e.g. `olano` vs `nano`). Use the scoped `@olano/...` name (already configured). |
| npm `E404` right after publish | Registry read-CDN propagation lag; the `PUT` already succeeded. Re-check after a few seconds. |
| PyPI `403 "Host not in allowlist: upload.pypi.org"` | Network egress blocks uploads. Publish from a network that allows `upload.pypi.org`. |
| PyPI `403` on first publish | Project-scoped token cannot create a new project. Use an account-scoped token (or a Trusted Publisher). |

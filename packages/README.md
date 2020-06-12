This directory contains all packages and package support files used for BigBlueButton.

Each directory represents one package with some exceptions:
- `checkouts` contains checkouts of all relevant projects, they are not committed
- `sources` contains the sources of all projects and respective patches
- `x2nix` contains some static files for various `*2nix` projects. They should never need updates

Most directories contain a `generate.sh` script, they are called from the `generate.sh` script in this directory.
`utils.sh` contains some useful functions that are shared between directories.

The scripts mimic `make` by building only what changed, but instead of relying on the `mtime` of files, we rely on the git dirty/untracked status.

## Package name mapping

Since BigBlueButton devs seem unable to keep a consistent naming scheme, some packages were renamed here for consistency:

| BigBlueButton directory | bbb4nix directory    | Attribute               |
|-------------------------|----------------------|-------------------------|

## Maintainer info

To add a package, just add it to the bottom of `generate.sh`, create the respective directory here, and read maintainer info of `sources/`.

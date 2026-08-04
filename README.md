# AUR packages

[![CI](https://github.com/chadsr/aur-packages/actions/workflows/ci.yml/badge.svg)](https://github.com/chadsr/aur-packages/actions/workflows/ci.yml)

## Adding a package

1. Create a directory named after the package.
1. Add the initial `PKGBUILD` and `.SRCINFO` files to the directory.
1. Add a comment after `pkgver` with the [Renovate datasource](https://docs.renovatebot.com/modules/datasource/) and package name:

```bash
pkgver=1.2.3 # renovate: datasource=github-tags depName=git/git
```

## License

The code in this repository is licensed under the MIT license.
Each package is distributed under the license declared in its `PKGBUILD`.

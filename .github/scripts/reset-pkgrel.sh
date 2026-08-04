#!/usr/bin/env bash
set -euo pipefail

pkgdir="${1:-}"
base_sha="${2:-}"

if [ -z "$pkgdir" ]; then
	echo "usage: $0 <pkgdir> [base-sha]" >&2
	exit 2
fi

pkgbuild="${pkgdir}/PKGBUILD"

if [ ! -f "$pkgbuild" ]; then
	echo "reset-pkgrel: ${pkgbuild} not found" >&2
	exit 1
fi

new_pkgver=$(awk '/^pkgver=/{sub(/^pkgver=/,""); print $1; exit}' "$pkgbuild")

if [ -z "$base_sha" ]; then
	echo "no base sha given; leaving pkgrel unchanged"
	exit 0
fi

if base_pkgbuild=$(git show "${base_sha}:${pkgbuild}" 2>/dev/null); then
	old_pkgver=$(printf '%s\n' "$base_pkgbuild" | awk '/^pkgver=/{sub(/^pkgver=/,""); print $1; exit}')
else
	old_pkgver=""
fi

if [ -z "$old_pkgver" ]; then
	echo "no base PKGBUILD at ${base_sha}; leaving pkgrel unchanged"
elif [ "$old_pkgver" != "$new_pkgver" ]; then
	sed -i 's/^pkgrel=.*/pkgrel=1/' "$pkgbuild"
	echo "pkgver changed (${old_pkgver} -> ${new_pkgver}): reset pkgrel to 1"
else
	echo "pkgver unchanged (${new_pkgver}); leaving pkgrel"
fi

#!/usr/bin/env bash
set -euo pipefail

# Nested makepkg build scripts may append to $GITHUB_ENV.
# In a container action that file is host-owned and read-only to the builder,
# so repoint to writable files to avoid "Permission denied" during the build.
export GITHUB_ENV=/tmp/.gh-env
export GITHUB_PATH=/tmp/.gh-path
: >"$GITHUB_ENV"
: >"$GITHUB_PATH"

echo "::group::Updating"
sudo pacman -Syu --noconfirm
echo "::endgroup::"

# Set path
WORKPATH=$GITHUB_WORKSPACE/$INPUT_PKGNAME
HOME=/home/builder
echo "::group::Copying files from $WORKPATH to $HOME/gh-action"
# Set path permision
cd $HOME
mkdir gh-action
cd gh-action
cp -rfv "$GITHUB_WORKSPACE"/.git ./
cp -fv "$WORKPATH"/* .
echo "::endgroup::"

echo "::group::Updating archlinux-keyring"
sudo pacman -S --noconfirm archlinux-keyring
echo "::endgroup::"

echo "::group::Updating checksums on PKGBUILD"
updpkgsums
git diff PKGBUILD
echo "::endgroup::"

echo "::group::Installing depends using yay"
depends=()
makedepends=()
# shellcheck source=/dev/null
source PKGBUILD
# shellcheck disable=SC2154
yay -Syu --removemake --needed --noconfirm "${depends[@]}" "${makedepends[@]}"
echo "::endgroup::"

echo "::group::Running makepkg"
makepkg
echo "::endgroup::"

echo "::group::namcap (built package)"
namcap ./*.pkg.tar.* >namcap-pkg.log 2>&1 || true
if [ -s namcap-pkg.log ]; then
	while IFS= read -r line; do
		echo "::warning file=${INPUT_PKGNAME}/PKGBUILD::namcap: ${line}"
	done <namcap-pkg.log
else
	echo "namcap: no issues found"
fi
echo "::endgroup::"

echo "::group::Generating new .SRCINFO based on PKGBUILD"
makepkg --printsrcinfo >.SRCINFO
git diff .SRCINFO
echo "::endgroup::"

echo "::group::Copying files from $HOME/gh-action to $WORKPATH"
sudo cp -fv PKGBUILD "$WORKPATH"/PKGBUILD
sudo cp -fv .SRCINFO "$WORKPATH"/.SRCINFO
echo "::endgroup::"

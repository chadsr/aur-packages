#!/usr/bin/env bash
# bump alongside the package's _ghostty_sha1
_zigver=0.16.0

case "$(uname -m)" in
x86_64)
	_zigsha=70e49664a74374b48b51e6f3fdfbf437f6395d42509050588bd49abe52ba3d00
	;;
aarch64)
	_zigsha=ea4b09bfb22ec6f6c6ceac57ab63efb6b46e17ab08d21f69f3a48b38e1534f17
	;;
*)
	echo "::error::unsupported arch $(uname -m)"
	exit 1
	;;
esac

_zigdir="$HOME/zig-$_zigver"
mkdir -p "$_zigdir"
curl -fsSL "https://ziglang.org/download/$_zigver/zig-$(uname -m)-linux-$_zigver.tar.xz" -o "$_zigdir/zig.tar.xz"
echo "$_zigsha  $_zigdir/zig.tar.xz" | sha256sum -c -
tar -xJf "$_zigdir/zig.tar.xz" --strip-components=1 -C "$_zigdir"
export PATH="$_zigdir:$PATH"

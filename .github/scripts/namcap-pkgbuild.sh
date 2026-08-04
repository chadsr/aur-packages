#!/usr/bin/env bash
set -euo pipefail

shopt -s nullglob
found=0
summary="${GITHUB_STEP_SUMMARY:-}"

for p in */PKGBUILD; do
	pkgdir=$(dirname "$p")
	mapfile -t lines < <(cd "$pkgdir" && namcap PKGBUILD 2>&1 || true)
	if [ "${#lines[@]}" -gt 0 ]; then
		found=1
		for line in "${lines[@]}"; do
			[ -z "$line" ] && continue
			echo "::warning file=${pkgdir}/PKGBUILD::namcap: ${line}"
		done
		if [ -n "$summary" ]; then
			{
				echo "### namcap: ${pkgdir}"
				echo '```'
				printf '%s\n' "${lines[@]}"
				echo '```'
			} >>"$summary"
		fi
	fi
done

if [ "$found" -eq 0 ]; then
	echo "namcap: no issues in any PKGBUILD"
fi

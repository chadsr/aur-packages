#!/usr/bin/env bash
set -euo pipefail

git config user.name "github-actions[bot]"
git config user.email "41898282+github-actions[bot]@users.noreply.github.com"
git add -- '*/PKGBUILD' '*/.SRCINFO'
if git diff --cached --quiet; then
	echo "changes_detected=false" >>"$GITHUB_OUTPUT"
	exit 0
fi
git commit -m 'chore(updpkgsums): update checksums'
git push "https://x-access-token:${PAT}@github.com/${GITHUB_REPOSITORY}.git" "HEAD:${GITHUB_HEAD_REF}"
echo "changes_detected=true" >>"$GITHUB_OUTPUT"

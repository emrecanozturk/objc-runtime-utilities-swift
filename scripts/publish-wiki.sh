#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."

repo_slug="${REPO_SLUG:-}"
if [[ -z "$repo_slug" ]]; then
  repo_slug="$(gh repo view --json nameWithOwner -q .nameWithOwner)"
fi

if [[ -z "$repo_slug" ]]; then
  echo "Set REPO_SLUG=owner/repo or run from a GitHub-backed checkout." >&2
  exit 1
fi

wiki_url="https://github.com/${repo_slug}.wiki.git"
wiki_dir=".build/wiki-publish"

rm -rf "$wiki_dir"
if ! git clone "$wiki_url" "$wiki_dir"; then
  echo "Could not clone $wiki_url." >&2
  echo "If the repo wiki was just enabled, create the first Home page in the GitHub UI, then rerun this script." >&2
  exit 1
fi

rsync -a --delete --exclude ".git/" docs/wiki/ "$wiki_dir/"

if [[ -z "$(git -C "$wiki_dir" status --short)" ]]; then
  echo "Wiki is already up to date."
  exit 0
fi

git -C "$wiki_dir" add -A
git -C "$wiki_dir" commit -m "Update wiki"
git -C "$wiki_dir" push

echo "Wiki published to $wiki_url."

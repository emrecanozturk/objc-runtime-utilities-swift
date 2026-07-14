#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."

required_wiki_files=(
  "docs/wiki/Home.md"
  "docs/wiki/_Sidebar.md"
  "docs/wiki/_Footer.md"
  "docs/wiki/Getting-Started.md"
  "docs/wiki/API-Reference.md"
  "docs/wiki/App-Store-Safety.md"
  "docs/wiki/SwiftUI-UIKit-Bridges.md"
  "docs/wiki/Release-Checklist.md"
)

for file in "${required_wiki_files[@]}"; do
  if [[ ! -s "$file" ]]; then
    echo "Missing or empty wiki file: $file" >&2
    exit 1
  fi
done

contains_text() {
  local pattern="$1"
  shift

  if command -v rg >/dev/null 2>&1; then
    rg -q "$pattern" "$@"
  else
    grep -Rqs "$pattern" "$@"
  fi
}

if ! contains_text "What This Can and Cannot Do" README.md docs/CAN-CANNOT.md; then
  echo "Expected can/cannot documentation was not found." >&2
  exit 1
fi

if ! contains_text "App Store" README.md docs/APP-STORE-SAFETY.md docs/wiki/App-Store-Safety.md; then
  echo "Expected App Store safety documentation was not found." >&2
  exit 1
fi

echo "Documentation checks passed."

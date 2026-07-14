#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."

required_files=(
  "Package.swift"
  "README.md"
  "LICENSE"
  "NOTICE"
  "CONTRIBUTING.md"
  "SECURITY.md"
  "CODE_OF_CONDUCT.md"
  "SUPPORT.md"
  "CHANGELOG.md"
  "ROADMAP.md"
  "docs/CAN-CANNOT.md"
  "docs/API.md"
  "docs/ARCHITECTURE.md"
  "docs/APP-STORE-SAFETY.md"
  "docs/SWIFTUI-BRIDGES.md"
  "docs/RELEASE.md"
  ".github/workflows/ci.yml"
  ".github/workflows/codeql.yml"
  ".github/workflows/docs.yml"
  ".github/workflows/release.yml"
)

for file in "${required_files[@]}"; do
  if [[ ! -f "$file" ]]; then
    echo "Missing required file: $file" >&2
    exit 1
  fi
done

if rg -n "Egemsoft|TestCribe|internal-only|TODO:|FIXME:" README.md Sources Tests docs Examples .github >/tmp/oru-public-ready-scan.txt; then
  cat /tmp/oru-public-ready-scan.txt >&2
  echo "Public readiness scan found blocked terms." >&2
  exit 1
fi

swift package dump-package >/dev/null
swift test

echo "Public readiness checks passed."

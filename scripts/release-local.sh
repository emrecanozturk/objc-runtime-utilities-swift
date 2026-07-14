#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."

bash scripts/check-docs.sh
swift test
swift build -c release

echo "Local release checks passed."

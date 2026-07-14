# Release Checklist

Run:

```bash
swift test
bash scripts/check-public-ready.sh
bash scripts/check-docs.sh
bash scripts/release-local.sh
```

Then tag:

```bash
git tag 0.1.0
git push origin 0.1.0
```

Confirm CI, documentation checks, CodeQL, and the release workflow on GitHub.

# Release Checklist

1. Update `CHANGELOG.md`.
2. Run local checks:

   ```bash
   swift test
   bash scripts/check-public-ready.sh
   bash scripts/check-docs.sh
   bash scripts/release-local.sh
   ```

3. Tag the release:

   ```bash
   git tag 0.1.0
   git push origin 0.1.0
   ```

4. Confirm GitHub Actions:

   - CI
   - Documentation
   - CodeQL
   - Release

5. Publish wiki updates if needed:

   ```bash
   REPO_SLUG=emrecanozturk/objc-runtime-utilities-swift bash scripts/publish-wiki.sh
   ```

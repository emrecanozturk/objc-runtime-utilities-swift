# Contributing

Thanks for helping make Objective-C runtime interop safer for Swift users.

## Development

Use the current stable Xcode or Swift toolchain for Apple platforms.

```bash
swift test
bash scripts/check-public-ready.sh
bash scripts/check-docs.sh
```

## Pull Requests

- Keep runtime behavior narrow and explicit.
- Add or update tests for every behavior change.
- Document App Store safety boundaries when adding runtime hooks.
- Avoid private Apple APIs and undocumented framework internals.
- Prefer additive APIs over breaking changes before `1.0.0`.

## API Design

Public API should feel like Swift:

- typed values over `Any` where practical
- receipts or observation tokens for reversible behavior
- small scopes instead of global mutation
- documentation that states tradeoffs plainly

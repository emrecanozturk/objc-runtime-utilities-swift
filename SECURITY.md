# Security Policy

## Supported Versions

Security fixes are handled on the latest released minor version.

## Reporting a Vulnerability

Please open a private security advisory on GitHub or contact the maintainer
through the repository owner profile.

Do not publish exploit details before there is a fix or mitigation.

## Scope

This package wraps public runtime APIs. Reports are in scope when they show:

- unsafe memory behavior introduced by this package
- unexpectedly broad method exchange behavior
- documentation that encourages private API usage
- CI or release process weaknesses

Misuse of public runtime APIs in downstream apps is usually out of scope, but
documentation improvements are welcome.

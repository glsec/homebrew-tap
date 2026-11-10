# Security policy

This repository is the Homebrew tap for [glsec](https://github.com/glsec/glsec). Report a security problem in it, or in glsec itself, as described in [glsec's security policy](https://github.com/glsec/glsec/blob/main/SECURITY.md), through a private vulnerability report and not a public issue.

The tap only pulls published releases: [`scripts/update.sh`](scripts/update.sh) checks each release archive against glsec's build [provenance attestation](https://github.com/glsec/glsec#verifying-a-release) and `checksums.txt` before the formula changes, and no token from the glsec repository is used. See the [README](README.md) for how the formula is updated.

# Homebrew tap for glsec

[glsec](https://github.com/glsec/glsec) is a security linter for GitLab CI/CD pipelines.

```sh
brew install glsec/tap/glsec
```

Works on macOS and Linux, on Intel and ARM. `brew upgrade glsec` gets new releases.

## How the formula is updated

[`update.yml`](.github/workflows/update.yml) runs once a day and can be started by hand after a release. [`scripts/update.sh`](scripts/update.sh) downloads the release archives, checks each one against the [provenance attestation](https://github.com/glsec/glsec#verifying-a-release) of glsec's release workflow and against `checksums.txt`, and writes `Formula/glsec.rb`. The workflow then installs the new formula, runs its test and commits it.

No token from the glsec repository is involved: the tap pulls releases, nothing pushes into it.

Problems with glsec itself go to [glsec/glsec](https://github.com/glsec/glsec/issues).

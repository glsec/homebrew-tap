#!/usr/bin/env bash
# Writes Formula/glsec.rb for the latest glsec release. Every archive is
# checked against the provenance attestation of glsec's release workflow and
# against checksums.txt before its checksum goes into the formula.
# Usage: scripts/update.sh [tag]   (default: the latest release)
set -euo pipefail

repo=glsec/glsec
signer=glsec/glsec/.github/workflows/build-release.yml
tag=${1:-$(gh api "repos/$repo/releases/latest" --jq .tag_name)}
version=${tag#v}
formula=Formula/glsec.rb

work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT

platforms="darwin_arm64 darwin_amd64 linux_arm64 linux_amd64"
patterns=(-p checksums.txt)
for p in $platforms; do
  patterns+=(-p "glsec_${version}_${p}.tar.gz")
done
gh release download "$tag" -R "$repo" -D "$work" "${patterns[@]}"

for f in "$work"/checksums.txt "$work"/*.tar.gz; do
  gh attestation verify "$f" -R "$repo" --signer-workflow "$signer" >/dev/null
done

for p in $platforms; do
  name="glsec_${version}_${p}.tar.gz"
  expected=$(awk -v n="$name" '$2 == n { print $1 }' "$work/checksums.txt")
  actual=$(shasum -a 256 "$work/$name" | awk '{ print $1 }')
  if [[ -z $expected || $expected != "$actual" ]]; then
    echo "checksum mismatch for $name" >&2
    exit 1
  fi
  printf -v "sha_$p" %s "$actual"
done

url="https://github.com/$repo/releases/download/v#{version}/glsec_#{version}"
cat > "$formula" <<RUBY
# Written by scripts/update.sh from the release's checksums.txt, after checking
# each archive's provenance attestation. Don't edit by hand.
class Glsec < Formula
  desc "Security linter for GitLab CI/CD pipelines"
  homepage "https://glsec.github.io"
  version "$version"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "${url}_darwin_arm64.tar.gz"
      sha256 "${sha_darwin_arm64}"
    end
    on_intel do
      url "${url}_darwin_amd64.tar.gz"
      sha256 "${sha_darwin_amd64}"
    end
  end

  on_linux do
    on_arm do
      url "${url}_linux_arm64.tar.gz"
      sha256 "${sha_linux_arm64}"
    end
    on_intel do
      url "${url}_linux_amd64.tar.gz"
      sha256 "${sha_linux_amd64}"
    end
  end

  def install
    bin.install "glsec"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/glsec --version")
    (testpath/".gitlab-ci.yml").write <<~YAML
      test:
        image: alpine:latest
        script: [echo hi]
    YAML
    assert_match "GL001", shell_output("#{bin}/glsec --no-color .gitlab-ci.yml", 1)
  end
end
RUBY
echo "$formula: glsec $version"

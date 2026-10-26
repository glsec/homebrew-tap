# Written by scripts/update.sh from the release's checksums.txt, after checking
# each archive's provenance attestation. Don't edit by hand.
class Glsec < Formula
  desc "Security linter for GitLab CI/CD pipelines"
  homepage "https://glsec.github.io"
  version "1.24.0"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/glsec/glsec/releases/download/v#{version}/glsec_#{version}_darwin_arm64.tar.gz"
      sha256 "382633ad93dbd508db3796d9c95001320a6ec37f668896c5d08a0fc9c5506621"
    end
    on_intel do
      url "https://github.com/glsec/glsec/releases/download/v#{version}/glsec_#{version}_darwin_amd64.tar.gz"
      sha256 "1a70227ce71c4e7f1b8cbe8b2394725b1af3fd5f48280b24bab4d7d06c6131ed"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/glsec/glsec/releases/download/v#{version}/glsec_#{version}_linux_arm64.tar.gz"
      sha256 "7a447a855b082d7e031afc9ab4673e6f7b1156ad8667e099faa15f37f3c20c88"
    end
    on_intel do
      url "https://github.com/glsec/glsec/releases/download/v#{version}/glsec_#{version}_linux_amd64.tar.gz"
      sha256 "13dd1968083e729e8375c142f4b1245784728e428699198e68236d184672acef"
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

# Written by scripts/update.sh from the release's checksums.txt, after checking
# each archive's provenance attestation. Don't edit by hand.
class Glsec < Formula
  desc "Security linter for GitLab CI/CD pipelines"
  homepage "https://glsec.github.io"
  version "1.23.0"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/glsec/glsec/releases/download/v#{version}/glsec_#{version}_darwin_arm64.tar.gz"
      sha256 "8629f8aa27f84e5b6feace80da02f26ddd877f3f65e7965a20e5d306b65e2a2b"
    end
    on_intel do
      url "https://github.com/glsec/glsec/releases/download/v#{version}/glsec_#{version}_darwin_amd64.tar.gz"
      sha256 "ac8799197dfe6014544341fdc683c25fea60d91993b7f28bd13866e9e871390a"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/glsec/glsec/releases/download/v#{version}/glsec_#{version}_linux_arm64.tar.gz"
      sha256 "ff07d690135afaa0a658e497604bb3a304558c4e8f752595f639e17710abeb36"
    end
    on_intel do
      url "https://github.com/glsec/glsec/releases/download/v#{version}/glsec_#{version}_linux_amd64.tar.gz"
      sha256 "513be1af9c95b8a06a8d6862ac6a4edf4ffdabf2cc1ac233600d73b32d710999"
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

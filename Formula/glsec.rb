# Written by scripts/update.sh from the release's checksums.txt, after checking
# each archive's provenance attestation. Don't edit by hand.
class Glsec < Formula
  desc "Security linter for GitLab CI/CD pipelines"
  homepage "https://glsec.github.io"
  version "1.25.0"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/glsec/glsec/releases/download/v#{version}/glsec_#{version}_darwin_arm64.tar.gz"
      sha256 "f6a73b9917445e16d1c5a8e8d8682718984df1bf3aa6e80aaf587e2a743b6773"
    end
    on_intel do
      url "https://github.com/glsec/glsec/releases/download/v#{version}/glsec_#{version}_darwin_amd64.tar.gz"
      sha256 "be16c64d0500bbfdf1cba4c04e4465cbac808bc1b45c7cda9389a42f31bb12a2"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/glsec/glsec/releases/download/v#{version}/glsec_#{version}_linux_arm64.tar.gz"
      sha256 "a9378052b6c14d8c7d2b6c950daa8b0ff1d4c60bf6b1097f1ad571461bc77b83"
    end
    on_intel do
      url "https://github.com/glsec/glsec/releases/download/v#{version}/glsec_#{version}_linux_amd64.tar.gz"
      sha256 "36b9565e6e3c79b52a3ce2d447cb18550535034ecba1e4526afd870d091140ae"
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

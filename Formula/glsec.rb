# Written by scripts/update.sh from the release's checksums.txt, after checking
# each archive's provenance attestation. Don't edit by hand.
class Glsec < Formula
  desc "Security linter for GitLab CI/CD pipelines"
  homepage "https://glsec.github.io"
  version "1.29.0"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/glsec/glsec/releases/download/v#{version}/glsec_#{version}_darwin_arm64.tar.gz"
      sha256 "7ec18d0b1a5df11bcdbf0ae580a6fe77b574c536ce51d1997bbf72f5892e700c"
    end
    on_intel do
      url "https://github.com/glsec/glsec/releases/download/v#{version}/glsec_#{version}_darwin_amd64.tar.gz"
      sha256 "de20ccbd7d02e3ab2f525f9793f365b01ac594244b3b5c1371e3807b4c3f9ae6"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/glsec/glsec/releases/download/v#{version}/glsec_#{version}_linux_arm64.tar.gz"
      sha256 "e444ca2676b6ce761d00662dd3a5d9a071f84de4801cb057e6793cb493f17e39"
    end
    on_intel do
      url "https://github.com/glsec/glsec/releases/download/v#{version}/glsec_#{version}_linux_amd64.tar.gz"
      sha256 "3be7d6a42dd5039540762d10630f1231eecfb362a722111ba5724143fde89dcd"
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

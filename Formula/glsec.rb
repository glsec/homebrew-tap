# Written by scripts/update.sh from the release's checksums.txt, after checking
# each archive's provenance attestation. Don't edit by hand.
class Glsec < Formula
  desc "Security linter for GitLab CI/CD pipelines"
  homepage "https://glsec.github.io"
  version "1.26.0"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/glsec/glsec/releases/download/v#{version}/glsec_#{version}_darwin_arm64.tar.gz"
      sha256 "c2a65b30570c51a491797f4139c8f47a4e064eda91c6cf2f813927b56f565d39"
    end
    on_intel do
      url "https://github.com/glsec/glsec/releases/download/v#{version}/glsec_#{version}_darwin_amd64.tar.gz"
      sha256 "5557bd3233906024710049ce6108c598901c9a0463cd4b0e08ad4b5c3d41843a"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/glsec/glsec/releases/download/v#{version}/glsec_#{version}_linux_arm64.tar.gz"
      sha256 "a9b2acea7379a7deb6228cc6e9f26249342f816863bb1c236f7027f9293eee6f"
    end
    on_intel do
      url "https://github.com/glsec/glsec/releases/download/v#{version}/glsec_#{version}_linux_amd64.tar.gz"
      sha256 "1ce80a53a546aeff18dc90360c72d890eb15dcf80bb368e288b08698be680c5d"
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

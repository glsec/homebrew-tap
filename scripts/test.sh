#!/usr/bin/env bash
# Installs Formula/glsec.rb from a local copy of this tap and runs its test.
set -euo pipefail

if [ ! -f Formula/glsec.rb ]; then
  echo "no formula yet"
  exit 0
fi

tap="$(brew --repository)/Library/Taps/glsec/homebrew-tap"
rm -rf "$tap"
mkdir -p "$tap"
cp -R Formula "$tap/"
brew style glsec/tap/glsec
brew install glsec/tap/glsec
brew test glsec/tap/glsec
glsec --version

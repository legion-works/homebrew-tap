class Dormantctl < Formula
  desc "CLI and IPC client library for controlling and diagnosing dormant."
  homepage "https://github.com/legion-works/dormant"
  version "0.7.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/legion-works/dormant/releases/download/v0.7.0/dormantctl-aarch64-apple-darwin.tar.xz"
      sha256 "60c63475d9dbf850cd2a8a6174c6e53695530e115d37942206c1530375b3e486"
    end
    if Hardware::CPU.intel?
      url "https://github.com/legion-works/dormant/releases/download/v0.7.0/dormantctl-x86_64-apple-darwin.tar.xz"
      sha256 "3dbda7d8051fac4ce17b3229d2f216220c07a169616a751de3782308b1c8ff23"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/legion-works/dormant/releases/download/v0.7.0/dormantctl-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "c4d4ad1d9b0c2b75bdc4d208f2965f2228d64ca125cfe9225ab91e097010df1d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/legion-works/dormant/releases/download/v0.7.0/dormantctl-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "b56442cd3ddc8f1053e8719b25972b6e1f53caba660223202a9d885bf3634a2e"
    end
  end
  license any_of: ["MIT", "Apache-2.0"]

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "dormantctl" if OS.mac? && Hardware::CPU.arm?
    bin.install "dormantctl" if OS.mac? && Hardware::CPU.intel?
    bin.install "dormantctl" if OS.linux? && Hardware::CPU.arm?
    bin.install "dormantctl" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end

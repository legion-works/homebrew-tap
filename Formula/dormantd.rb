class Dormantd < Formula
  desc "Daemon binary for proximity-driven display blanking and wake control."
  homepage "https://github.com/legion-works/dormant"
  version "0.9.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/legion-works/dormant/releases/download/v0.9.1/dormantd-aarch64-apple-darwin.tar.xz"
      sha256 "84b92063dfe25a279723415c2f683a78f976b1a8f7e85129f875e8f866772caa"
    end
    if Hardware::CPU.intel?
      url "https://github.com/legion-works/dormant/releases/download/v0.9.1/dormantd-x86_64-apple-darwin.tar.xz"
      sha256 "cd946fdb0eaa18e1a02ce2b39134ea0cf52222da983769d9fd57f9b736f1f756"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/legion-works/dormant/releases/download/v0.9.1/dormantd-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "6d96bf2075d84f6064882a696fbb0c39be8a69171b7ae7a5a6c0fe35eac1a9b5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/legion-works/dormant/releases/download/v0.9.1/dormantd-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "6dc989a03777054a0d15410be6d8f91ad57d9f3606049434d19331d26d96360e"
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
    bin.install "dormantd" if OS.mac? && Hardware::CPU.arm?
    bin.install "dormantd" if OS.mac? && Hardware::CPU.intel?
    bin.install "dormantd" if OS.linux? && Hardware::CPU.arm?
    bin.install "dormantd" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end

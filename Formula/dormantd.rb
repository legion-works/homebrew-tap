class Dormantd < Formula
  desc "Daemon binary for proximity-driven display blanking and wake control."
  homepage "https://github.com/legion-works/dormant"
  version "0.7.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/legion-works/dormant/releases/download/v0.7.0/dormantd-aarch64-apple-darwin.tar.xz"
      sha256 "8a4b494fbdb8c28fa5d5cbf5f0c873caed09b362f58d04a22a607407e297fbe4"
    end
    if Hardware::CPU.intel?
      url "https://github.com/legion-works/dormant/releases/download/v0.7.0/dormantd-x86_64-apple-darwin.tar.xz"
      sha256 "11902aae07db6289aac906c8b49b52867d1c1535f1f1bf0d6bbd7e6d5922a0dc"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/legion-works/dormant/releases/download/v0.7.0/dormantd-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "5628304de012e128fbff7425133e51a4a6ce7528b4e964b0b53a02b221f50e66"
    end
    if Hardware::CPU.intel?
      url "https://github.com/legion-works/dormant/releases/download/v0.7.0/dormantd-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "3ac6020514f5ee5ddfd585b8936db0d543007a51d6ce40daa1d807ab5e81476a"
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

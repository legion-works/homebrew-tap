class Dormantd < Formula
  desc "Daemon binary for proximity-driven display blanking and wake control."
  homepage "https://github.com/legion-works/dormant"
  version "0.7.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/legion-works/dormant/releases/download/v0.7.1/dormantd-aarch64-apple-darwin.tar.xz"
      sha256 "889b79ababdf011972fd743b21d9645acd5dc1a3765e54df0f19ba0b8359f228"
    end
    if Hardware::CPU.intel?
      url "https://github.com/legion-works/dormant/releases/download/v0.7.1/dormantd-x86_64-apple-darwin.tar.xz"
      sha256 "ab44fbde4d53ba459d6fd7758d2eeab12385d7776bfef973ab24af915d67b11c"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/legion-works/dormant/releases/download/v0.7.1/dormantd-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "e03f38689199f6888f567b141b11bb6ed0e4e77178503ee913558dd660071f40"
    end
    if Hardware::CPU.intel?
      url "https://github.com/legion-works/dormant/releases/download/v0.7.1/dormantd-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "0769ec9d5801c6d9c0c27bd7aab8ff5af8f769474cbc7772d39bfd1952e07e89"
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

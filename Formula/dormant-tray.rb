class DormantTray < Formula
  desc "KDE StatusNotifierItem tray applet for monitoring and controlling dormantd."
  homepage "https://github.com/legion-works/dormant"
  version "0.12.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/legion-works/dormant/releases/download/v0.12.2/dormant-tray-aarch64-apple-darwin.tar.xz"
      sha256 "7ec733296f07d2e3dbee4f71fe076905d4903f2b4af447cbd04261f40ffff2a1"
    end
    if Hardware::CPU.intel?
      url "https://github.com/legion-works/dormant/releases/download/v0.12.2/dormant-tray-x86_64-apple-darwin.tar.xz"
      sha256 "077b05e75e4024f3f7b34024e7da39a7b8eafe9ec887a18c1bf0fd4fa2667a5f"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/legion-works/dormant/releases/download/v0.12.2/dormant-tray-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "d3a8a7d47f5e094472773c425f4e0ea93c6dbad99662e527660e6856df854889"
    end
    if Hardware::CPU.intel?
      url "https://github.com/legion-works/dormant/releases/download/v0.12.2/dormant-tray-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "ac506dd5c395f0706eccd949f214fe3c9f2214c27e8c392e60d175036ae569ab"
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
    bin.install "dormant-tray" if OS.mac? && Hardware::CPU.arm?
    bin.install "dormant-tray" if OS.mac? && Hardware::CPU.intel?
    bin.install "dormant-tray" if OS.linux? && Hardware::CPU.arm?
    bin.install "dormant-tray" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end

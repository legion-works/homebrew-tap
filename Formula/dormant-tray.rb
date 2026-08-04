class DormantTray < Formula
  desc "KDE StatusNotifierItem tray applet for monitoring and controlling dormantd."
  homepage "https://github.com/legion-works/dormant"
  version "0.11.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/legion-works/dormant/releases/download/v0.11.0/dormant-tray-aarch64-apple-darwin.tar.xz"
      sha256 "eaad32f549f24a2b0a25a6cda37be08938edeaaf5f5f9faa4af1686a4690341d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/legion-works/dormant/releases/download/v0.11.0/dormant-tray-x86_64-apple-darwin.tar.xz"
      sha256 "3f70386a88b09ee830a1586ebbfda48910bb4b026a16c01319455473381e5f41"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/legion-works/dormant/releases/download/v0.11.0/dormant-tray-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "9a4a16e71327f649ded12462e07da4dea2081a75a5cb90faeae8cb3ac2aacaa4"
    end
    if Hardware::CPU.intel?
      url "https://github.com/legion-works/dormant/releases/download/v0.11.0/dormant-tray-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "9dfd93c50ebf39162a476b919cd8da9f9adf6f952c74f4755432101cb3ceff40"
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

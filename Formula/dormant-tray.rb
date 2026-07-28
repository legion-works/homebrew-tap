class DormantTray < Formula
  desc "KDE StatusNotifierItem tray applet for monitoring and controlling dormantd."
  homepage "https://github.com/legion-works/dormant"
  version "0.9.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/legion-works/dormant/releases/download/v0.9.1/dormant-tray-aarch64-apple-darwin.tar.xz"
      sha256 "7f96ae66237b539b3e200cf17440f9a495d769b406429bad203cbd69fc72d573"
    end
    if Hardware::CPU.intel?
      url "https://github.com/legion-works/dormant/releases/download/v0.9.1/dormant-tray-x86_64-apple-darwin.tar.xz"
      sha256 "4ee70c925a403777db57e9526bce57d48172c53c78d6c9fc7bd290db60a16842"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/legion-works/dormant/releases/download/v0.9.1/dormant-tray-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "98a52fc90b439c4e11603e695bc1321e58160a0e124d8f0071d6d8ef37511409"
    end
    if Hardware::CPU.intel?
      url "https://github.com/legion-works/dormant/releases/download/v0.9.1/dormant-tray-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "69e866a4ad6c05064daee9b4581bae701b6542478a456821f5e4cb3c38bd1091"
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

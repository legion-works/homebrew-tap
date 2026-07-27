class DormantTray < Formula
  desc "KDE StatusNotifierItem tray applet for monitoring and controlling dormantd."
  homepage "https://github.com/legion-works/dormant"
  version "0.8.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/legion-works/dormant/releases/download/v0.8.1/dormant-tray-aarch64-apple-darwin.tar.xz"
      sha256 "38dfb8aeeb44c8b29d2962595f825a58c4373e13de2e9e61b49370b3e39f697a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/legion-works/dormant/releases/download/v0.8.1/dormant-tray-x86_64-apple-darwin.tar.xz"
      sha256 "c3bf5fbaa7468e136af748e700261e17470b8f899ad472608e94ea78d51f4758"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/legion-works/dormant/releases/download/v0.8.1/dormant-tray-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "8fd2c337cfb3dd879dfc578d4d46ce62eb814b55a6eb307c6f1ced1fb5d24eab"
    end
    if Hardware::CPU.intel?
      url "https://github.com/legion-works/dormant/releases/download/v0.8.1/dormant-tray-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "24498dba279ebce7523fedaf9e2f941687a9f6114a4071f6235b46da0b19c5e0"
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

class DormantTray < Formula
  desc "KDE StatusNotifierItem tray applet for monitoring and controlling dormantd."
  homepage "https://github.com/legion-works/dormant"
  version "0.12.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/legion-works/dormant/releases/download/v0.12.0/dormant-tray-aarch64-apple-darwin.tar.xz"
      sha256 "95ea5e8f7d30f45127f80b7bdba23ebe88c1f40d1d1cdbc9cb2735fd7257a527"
    end
    if Hardware::CPU.intel?
      url "https://github.com/legion-works/dormant/releases/download/v0.12.0/dormant-tray-x86_64-apple-darwin.tar.xz"
      sha256 "009b81b06facc8d148c5611e75b5ccf2f793d48ba92d59287e7c7ae1b4959670"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/legion-works/dormant/releases/download/v0.12.0/dormant-tray-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "1cee97fd5743b4d78032e815b45320ca1906bba25d18fb288c4dd0a118b4a57c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/legion-works/dormant/releases/download/v0.12.0/dormant-tray-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "5833772cac65f31d4fa598f7554df269bf3db3aa7a678fd5bfcd2c0dda4a47d7"
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

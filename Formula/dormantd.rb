class Dormantd < Formula
  desc "Daemon binary for proximity-driven display blanking and wake control."
  homepage "https://github.com/legion-works/dormant"
  version "0.10.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/legion-works/dormant/releases/download/v0.10.0/dormantd-aarch64-apple-darwin.tar.xz"
      sha256 "8cd72a41be9ef36bccc5c8cf18da06291ae5b35603ced27b02213240963e25e4"
    end
    if Hardware::CPU.intel?
      url "https://github.com/legion-works/dormant/releases/download/v0.10.0/dormantd-x86_64-apple-darwin.tar.xz"
      sha256 "58622687dfa1fa74faa584d19c2e28810803ff0260ab1f0e7fb3a829b1c30dc3"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/legion-works/dormant/releases/download/v0.10.0/dormantd-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "252d972a72fa549034af1c88e6bc261f442ac5e12471a9ba75aa530d5d28a81f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/legion-works/dormant/releases/download/v0.10.0/dormantd-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "198b08f81bfc412b1eef5c16c69d8b0d2f34975bcc5fe39bc405110608ef1115"
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

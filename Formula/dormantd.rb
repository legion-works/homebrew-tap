class Dormantd < Formula
  desc "Daemon binary for proximity-driven display blanking and wake control."
  homepage "https://github.com/legion-works/dormant"
  version "0.9.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/legion-works/dormant/releases/download/v0.9.0/dormantd-aarch64-apple-darwin.tar.xz"
      sha256 "f6ff0f9a6c6a077403227cbd6820ca116eb7018229f2a8ca075a807b3cffff5b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/legion-works/dormant/releases/download/v0.9.0/dormantd-x86_64-apple-darwin.tar.xz"
      sha256 "8cbca79e8a4bf2272a71f1bfaa9db0e42bd23dff534c07279032e8f76a68dee4"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/legion-works/dormant/releases/download/v0.9.0/dormantd-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "c64b8b7368ea39498f976c5f72c43159fd8c7e87267aeaaacb5610b1ff9d5e08"
    end
    if Hardware::CPU.intel?
      url "https://github.com/legion-works/dormant/releases/download/v0.9.0/dormantd-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "0357d63f8b7c36fe3f3e5761d46cf80728b50193aaf48a713ef3f0d115290a89"
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

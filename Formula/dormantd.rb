class Dormantd < Formula
  desc "Daemon binary for proximity-driven display blanking and wake control."
  homepage "https://github.com/legion-works/dormant"
  version "0.12.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/legion-works/dormant/releases/download/v0.12.4/dormantd-aarch64-apple-darwin.tar.xz"
      sha256 "2034e0a51ed838a73e819e4136fff575d5b6b4b90a76b70d5a8889a1ebf2df47"
    end
    if Hardware::CPU.intel?
      url "https://github.com/legion-works/dormant/releases/download/v0.12.4/dormantd-x86_64-apple-darwin.tar.xz"
      sha256 "9a1ac3c54ecb7ef29b7fdbc8441adf71aac59f92b4dd05812467715dc156657e"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/legion-works/dormant/releases/download/v0.12.4/dormantd-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "898b1ccc80c5db5b31d250c92abab3e1479a33b39a27ee073fa57f2d7bd9f1c7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/legion-works/dormant/releases/download/v0.12.4/dormantd-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "03803ffb68b922811aac3ccfc4abbe589cdf0f93ea453689b74ff0be5694742b"
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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "dormantd"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "dormantd"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "dormantd"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "dormantd"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end

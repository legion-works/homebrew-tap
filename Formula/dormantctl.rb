class Dormantctl < Formula
  desc "CLI and IPC client library for controlling and diagnosing dormant."
  homepage "https://github.com/legion-works/dormant"
  version "0.9.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/legion-works/dormant/releases/download/v0.9.1/dormantctl-aarch64-apple-darwin.tar.xz"
      sha256 "5a9eac4ab106513821ab2de89673748e02e879bfdc90dc2160972571e2863881"
    end
    if Hardware::CPU.intel?
      url "https://github.com/legion-works/dormant/releases/download/v0.9.1/dormantctl-x86_64-apple-darwin.tar.xz"
      sha256 "2d902b8291bb342d5d4e435b7275dc8088b0a119698dcf96a80f69d319f41938"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/legion-works/dormant/releases/download/v0.9.1/dormantctl-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "fe708793d6e3b8d48c75b9c7b4f00d4fac37651599930c8112feaeb3242dbab2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/legion-works/dormant/releases/download/v0.9.1/dormantctl-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "21ce8ae1bb65936f5c813f5274f5bf42a2981e825dbb48e36d398be8b21f4130"
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
    bin.install "dormantctl" if OS.mac? && Hardware::CPU.arm?
    bin.install "dormantctl" if OS.mac? && Hardware::CPU.intel?
    bin.install "dormantctl" if OS.linux? && Hardware::CPU.arm?
    bin.install "dormantctl" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end

class Dormantctl < Formula
  desc "CLI and IPC client library for controlling and diagnosing dormant."
  homepage "https://github.com/legion-works/dormant"
  version "0.8.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/legion-works/dormant/releases/download/v0.8.1/dormantctl-aarch64-apple-darwin.tar.xz"
      sha256 "88ff0926c23fe3644b72489a9d4cc65e0e4f0f9a2e607c600e0ad5c65b6a7a95"
    end
    if Hardware::CPU.intel?
      url "https://github.com/legion-works/dormant/releases/download/v0.8.1/dormantctl-x86_64-apple-darwin.tar.xz"
      sha256 "2a2a69e1ba91d7e46f8df795ac50a644305f32b4d240b514d925055aa0cf6b31"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/legion-works/dormant/releases/download/v0.8.1/dormantctl-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "1266fab957c9da2c83117c2b1e9ceeadc99437f69f9a6d582fbdfade117beecd"
    end
    if Hardware::CPU.intel?
      url "https://github.com/legion-works/dormant/releases/download/v0.8.1/dormantctl-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "2c72312cad9547d44196941783af375800a369206c941bbdd22aedfe41f3d686"
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

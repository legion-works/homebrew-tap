class Dormantctl < Formula
  desc "CLI and IPC client library for controlling and diagnosing dormant."
  homepage "https://github.com/legion-works/dormant"
  version "0.12.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/legion-works/dormant/releases/download/v0.12.3/dormantctl-aarch64-apple-darwin.tar.xz"
      sha256 "b9f721c07c52dfbe7e1b3b760a459e9f330a01c349e19eab086ffac70a80465b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/legion-works/dormant/releases/download/v0.12.3/dormantctl-x86_64-apple-darwin.tar.xz"
      sha256 "2f76d34e8de35186c8c98f4c18eea2f8d2e896fa31cfc1a9c51867fb0cb1e344"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/legion-works/dormant/releases/download/v0.12.3/dormantctl-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "8864ef1a388c1cad0ef2f34feed169ca4238657cae66914cc65d5a4824cf5466"
    end
    if Hardware::CPU.intel?
      url "https://github.com/legion-works/dormant/releases/download/v0.12.3/dormantctl-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "480163137dc92ac2e350cae95d78f28365e9ce2e8d713746009dc6ff73a9fac3"
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
      bin.install "dormantctl"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "dormantctl"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "dormantctl"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "dormantctl"
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

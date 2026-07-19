class Dormantctl < Formula
  desc "CLI and IPC client library for controlling and diagnosing dormant."
  homepage "https://github.com/legion-works/dormant"
  version "0.5.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/legion-works/dormant/releases/download/v0.5.0/dormantctl-aarch64-apple-darwin.tar.xz"
      sha256 "57f6b472bd4382ef16f82093c36604d5e130dc06c5aa99e6dc13b6c30f6b4b25"
    end
    if Hardware::CPU.intel?
      url "https://github.com/legion-works/dormant/releases/download/v0.5.0/dormantctl-x86_64-apple-darwin.tar.xz"
      sha256 "7324b14fe9aa62502ac34c3994c3501a4260eab0460869c20cd792558331a074"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/legion-works/dormant/releases/download/v0.5.0/dormantctl-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "bf4277abda477f31b99a6b66e9a35e245d33a32905b6f23694476025abb6dcac"
    end
    if Hardware::CPU.intel?
      url "https://github.com/legion-works/dormant/releases/download/v0.5.0/dormantctl-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "6413c7abe7f881bdbc6400301bdfab08a5102f794e06635d78757b7d0bbbde3e"
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

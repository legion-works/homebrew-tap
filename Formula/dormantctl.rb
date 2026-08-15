class Dormantctl < Formula
  desc "CLI and IPC client library for controlling and diagnosing dormant."
  homepage "https://github.com/legion-works/dormant"
  version "0.12.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/legion-works/dormant/releases/download/v0.12.4/dormantctl-aarch64-apple-darwin.tar.xz"
      sha256 "0ecc3c186c168cf2351001777985d5562e9c6e2bd9beb3ba06ea68a092b6af1c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/legion-works/dormant/releases/download/v0.12.4/dormantctl-x86_64-apple-darwin.tar.xz"
      sha256 "2cd98efcfc1c3fd5061c85bba2659c4ccc0b627fc254d0ded4aeeccda9ff5ae9"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/legion-works/dormant/releases/download/v0.12.4/dormantctl-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "1d247d6c1b976029ba3ec75711434d4743f121e8915f6e8fcdd273bf67ce7202"
    end
    if Hardware::CPU.intel?
      url "https://github.com/legion-works/dormant/releases/download/v0.12.4/dormantctl-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "071e3ffb2b6eb2fdac7eb35524757a99342f1943be5e88f835819ff895bf9fa3"
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

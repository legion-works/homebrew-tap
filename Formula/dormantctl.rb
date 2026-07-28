class Dormantctl < Formula
  desc "CLI and IPC client library for controlling and diagnosing dormant."
  homepage "https://github.com/legion-works/dormant"
  version "0.9.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/legion-works/dormant/releases/download/v0.9.0/dormantctl-aarch64-apple-darwin.tar.xz"
      sha256 "0941088697059157ea8c6aba816bcfc5037696dfa0bd62f024b376ca502888b3"
    end
    if Hardware::CPU.intel?
      url "https://github.com/legion-works/dormant/releases/download/v0.9.0/dormantctl-x86_64-apple-darwin.tar.xz"
      sha256 "3645bb2d31cdf2cd8c07323f1da2ff8c2af8a082e13a0ae517e47eb65164ab87"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/legion-works/dormant/releases/download/v0.9.0/dormantctl-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "49f534c5a460692df13757f90b43b9b5198608116b382c276ee3ced83ad07d5e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/legion-works/dormant/releases/download/v0.9.0/dormantctl-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "11ee5c3d644adafefa39e604e493cc0f59766792eb3294c700753e25ae436b12"
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

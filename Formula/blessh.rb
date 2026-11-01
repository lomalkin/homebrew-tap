# Homebrew formula of blessh, published to the tap lomalkin/homebrew-tap by
# the release job; render.sh fills in the version, URL and checksum of the
# macOS tarball. One program is the client and the server; the server is
# a Homebrew service that `blessh server enable` starts
# (docs/macos-server.md).
class Blessh < Formula
  desc "SSH over Bluetooth Low Energy"
  homepage "https://github.com/lomalkin/blessh"
  url "https://github.com/lomalkin/blessh/releases/download/blessh-v0.2.0/blessh-0.2.0-macos.tar.gz"
  version "0.2.0"
  sha256 "6f05320d143d7aa4d301c6d10701f8f05ff074ef3e3d261494912b3d3066881b"
  license "BSD-2-Clause"

  depends_on :macos

  def install
    bin.install "blessh"
  end

  service do
    run [opt_bin/"blessh", "server", "run"]
    keep_alive true
    log_path var/"log/blessh.log"
    error_log_path var/"log/blessh.log"
  end

  def caveats
    <<~EOS
      Connect to a server nearby (macOS asks once whether blessh may use
      Bluetooth):
        blessh scan
        blessh user@server

      Serve this Mac over Bluetooth (asks for sudo once, to set up sshd on
      127.0.0.1; Remote Login does not have to be on):
        blessh server enable
      It runs as the Homebrew service blessh; stop it and remove the sshd
      setup with:
        blessh server disable
    EOS
  end

  test do
    assert_match "blessh #{version}", shell_output("#{bin}/blessh --version")
    assert_match "blessh server", shell_output("#{bin}/blessh server --help")
  end
end

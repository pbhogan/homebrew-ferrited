class Ferrited < Formula
  desc "Memcached-compatible cache server with persistence and replication"
  homepage "https://github.com/pbhogan/ferrited"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    on_arm do
      url "https://github.com/pbhogan/ferrited/releases/download/v1.0.0/ferrited-1.0.0-aarch64-apple-darwin.tar.gz"
      sha256 "eaeed614d4b3f1ede2f4df8bb838ffbd43f36944ae1c1da282fccf25e2744ade"
    end
    on_intel do
      url "https://github.com/pbhogan/ferrited/releases/download/v1.0.0/ferrited-1.0.0-x86_64-apple-darwin.tar.gz"
      sha256 "5ce82a413715f47fa630587095ccf4c25aacd0cb3e780a96eec9ce42d4f664c6"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/pbhogan/ferrited/releases/download/v1.0.0/ferrited-1.0.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "ba7cca4276139aaff1fb6a56afd5a43be563e67ef3bfe223e0a612fdd2a5ffd7"
    end
    on_intel do
      url "https://github.com/pbhogan/ferrited/releases/download/v1.0.0/ferrited-1.0.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "5450849ba243630aaf64f6311379bd513b857d6b5821ac718161dca3fec086dd"
    end
  end

  def install
    bin.install "ferrited"
  end

  service do
    run [opt_bin/"ferrited", "-l", "127.0.0.1"]
    keep_alive true
    log_path var/"log/ferrited.log"
    error_log_path var/"log/ferrited.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ferrited --version")

    port = free_port
    pid = spawn bin/"ferrited", "-p", port.to_s
    begin
      socket = nil
      20.times do
        socket = TCPSocket.new("127.0.0.1", port)
        break
      rescue Errno::ECONNREFUSED
        sleep 0.25
      end
      socket.write "version\r\n"
      assert_match "ferrited-#{version}", socket.gets
    ensure
      socket&.close
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end

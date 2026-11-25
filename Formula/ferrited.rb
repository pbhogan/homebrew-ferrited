class Ferrited < Formula
  desc "Memcached-compatible cache server with persistence and replication"
  homepage "https://github.com/pbhogan/ferrited"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    on_arm do
      url "https://github.com/pbhogan/ferrited/releases/download/v1.0.1/ferrited-1.0.1-aarch64-apple-darwin.tar.gz"
      sha256 "03e07089321ef2a9a810054803d3d097e51f78482414d2af4924b47f3aa97793"
    end
    on_intel do
      url "https://github.com/pbhogan/ferrited/releases/download/v1.0.1/ferrited-1.0.1-x86_64-apple-darwin.tar.gz"
      sha256 "0eaa3b8aa2010ace717cfdcdde3b58b4106a899b03b0c178bc864e4d6bc149f6"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/pbhogan/ferrited/releases/download/v1.0.1/ferrited-1.0.1-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "6f5e92734c1c6c832f29b51b4e45bfba4942923adc0a235bc99cd7038611841e"
    end
    on_intel do
      url "https://github.com/pbhogan/ferrited/releases/download/v1.0.1/ferrited-1.0.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "d528fd891840c240ac0f094a6b8ae68e316a9bbde3bc2f9f02f24a5c670a12ea"
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

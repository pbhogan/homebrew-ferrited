# homebrew-ferrited

Homebrew tap for [ferrited](https://github.com/pbhogan/ferrited), a memcached-compatible cache server with persistence and replication.

```bash
brew install pbhogan/ferrited/ferrited
```

To run it in the background on `127.0.0.1:11211`, in memory only:

```bash
brew services start ferrited
```

The log is in `$(brew --prefix)/var/log/ferrited.log`. For persistence, replication and other flags, run `ferrited` yourself; see the [README](https://github.com/pbhogan/ferrited#readme).

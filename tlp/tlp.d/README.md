TLP's config is overridden via drop-in files: anything in `/etc/tlp.d/*.conf` takes precedence over `/etc/tlp.conf`, so only the deltas from the defaults are tracked here.

Deploy from the repo root with:

```sh
make tlp
```

This copies the files to `/etc/tlp.d/` (root-owned, no symlink) and runs `tlp start` to apply them. Re-run after every change.

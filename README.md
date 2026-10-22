# apt

An apt repository for my own tools: [smoothcast](https://github.com/tihonove/smoothcast),
[wl-castlog](https://github.com/tihonove/wl-castlog),
[wf-recorder-nc](https://github.com/tihonove/wf-recorder). Ubuntu 24.04 (noble) and
26.04 (resolute), amd64 and arm64.

```sh
curl -fsSL https://tihonove.github.io/apt/install.sh | sudo sh
```

Puts the key into `/etc/apt/keyrings/tihonove.asc`, the source into
`/etc/apt/sources.list.d/tihonove.sources` and installs all three packages (or
just the ones given: `| sudo sh -s -- wl-castlog`). Updates come with a regular
`apt upgrade`.

## How it works

- Each tool builds its `.deb` files in CI on a tag and attaches them to a
  GitHub Release.
- Here, `publish` checks the latest releases of the repos listed in `sources`
  every hour. If something changed, `build` assembles the repository with
  reprepro, signs it with the key from the `APT_SIGNING_KEY` secret and deploys
  it to GitHub Pages. The tools' `./release` script triggers
  `publish` right after its packages are built, so there's no wait; by hand:
  `gh workflow run publish -R tihonove/apt`.
- A version with `~noble`/`~resolute` goes only into its own Ubuntu release
  (those link against system libraries); one without a suffix goes into all of
  them (the static smoothcast).
- New Ubuntu release: a block in `conf/distributions.in` and a line in the CI
  matrix of the tools.
- Signing key: `init-key`. The private part lives only in the secret, the
  public one in `key.asc`.

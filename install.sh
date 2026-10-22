#!/bin/sh
# Add the tihonove apt repository and install the packages:
#   curl -fsSL https://tihonove.github.io/apt/install.sh | sudo sh
#   curl -fsSL https://tihonove.github.io/apt/install.sh | sudo sh -s -- wl-castlog   # just these
# Safe to rerun: rewrites the key and the source, apt installs what's missing.
# Updates then arrive with a regular apt upgrade.
set -eu

base=https://tihonove.github.io/apt
codenames="@CODENAMES@"

. /etc/os-release
case " $codenames " in
    *" $VERSION_CODENAME "*) ;;
    *) echo "No builds for $VERSION_CODENAME (available: $codenames)" >&2; exit 1 ;;
esac

install -d -m 755 /etc/apt/keyrings
curl -fsSL "$base/key.asc" -o /etc/apt/keyrings/tihonove.asc
chmod 644 /etc/apt/keyrings/tihonove.asc

cat > /etc/apt/sources.list.d/tihonove.sources <<SRC
Types: deb
URIs: $base
Suites: $VERSION_CODENAME
Components: main
Signed-By: /etc/apt/keyrings/tihonove.asc
SRC

apt-get update
[ $# -gt 0 ] || set -- smoothcast wl-castlog wf-recorder-nc
apt-get install -y "$@"

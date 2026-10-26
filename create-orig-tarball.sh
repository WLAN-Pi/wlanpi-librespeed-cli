#!/bin/sh
set -eu

cd "$(dirname "$0")"

version=$(sed -n '1s/.*(\([^)]*\)).*/\1/p' debian/changelog)
upstream=${version%-*}
source=$(sed -n '1s/^\([^ ][^ ]*\) (.*/\1/p' debian/changelog)

if [ -z "$version" ] || [ -z "$upstream" ] || [ -z "$source" ] || [ "$upstream" = "$version" ]; then
    echo "changelog version has no Debian revision: ${version}" >&2
    exit 1
fi

# dpkg-source for 3.0 (quilt) reads ../<source>_<upstream>.orig.tar.gz.
# The shared sbuild action runs dpkg-source itself, so the tarball has to
# exist first.
tar --exclude=./debian --exclude=./.git \
    -czf "../${source}_${upstream}.orig.tar.gz" .

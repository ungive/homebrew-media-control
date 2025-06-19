#!/bin/sh

set -e

if [ "$#" -ne 1 ]; then
  echo "Usage: $0 <version>"
  exit 1
fi

VERSION=$1
VERSION=${VERSION//v/}
REPO="ungive/media-control"
URL="https://github.com/${REPO}/archive/refs/tags/v${VERSION}.tar.gz"

TEMPDIR=$(mktemp -d)
curl -fSsL "$URL" -o "$TEMPDIR/source.tar.gz"
shasum -a 256 "$TEMPDIR/source.tar.gz" | awk '{ print $1 }'
rm -rf "$TEMPDIR"

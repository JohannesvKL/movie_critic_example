#!/usr/bin/env bash
set -euo pipefail

run1=$1
run2=$2

tmp1=$(mktemp)
tmp2=$(mktemp)

# Compute checksums relative to each directory, stripping paths
(cd "$run1" && find . -type f -exec sha256sum {} + | sort -k 2 > "$tmp1")
(cd "$run2" && find . -type f -exec sha256sum {} + | sort -k 2 > "$tmp2")

if diff -q "$tmp1" "$tmp2" >/dev/null; then
  echo "The runs are identical"
else
  echo "Differences found between runs"
  diff "$tmp1" "$tmp2" | head
fi

rm "$tmp1" "$tmp2"


#!/usr/bin/env bash
set -euo pipefail

# Colors
GREEN="\033[0;32m"
RED="\033[0;31m"
YELLOW="\033[1;33m"
NC="\033[0m"

# Usage check
if [[ $# -ne 2 ]]; then
  echo -e "${YELLOW}Usage:${NC} $0 <run1_dir> <run2_dir>"
  exit 1
fi

run1=$1
run2=$2

if [[ ! -d "$run1" || ! -d "$run2" ]]; then
  echo -e "${RED}Error:${NC} Both arguments must be valid directories."
  exit 1
fi

tmp1=$(mktemp)
tmp2=$(mktemp)
join_tmp=$(mktemp)

# Compute checksums recursively, relative to each directory
(cd "$run1" && find . -type f -exec sha256sum {} + | sort -k 2 > "$tmp1")
(cd "$run2" && find . -type f -exec sha256sum {} + | sort -k 2 > "$tmp2")

count1=$(wc -l < "$tmp1")
count2=$(wc -l < "$tmp2")

echo -e "Comparing directories:"
echo "  $run1 ($count1 files)"
echo "  $run2 ($count2 files)"
echo

# Join by relative filename
#   Fields after join: filename hash1 hash2
join -a1 -a2 -e "MISSING" -j 1 \
  <(awk '{print $2, $1}' "$tmp1" | sort) \
  <(awk '{print $2, $1}' "$tmp2" | sort) > "$join_tmp"

total=$(wc -l < "$join_tmp")
matches=$(awk '$2 == $3' "$join_tmp" | wc -l)
diffs=$(( total - matches ))

if (( diffs == 0 )); then
  echo -e "${GREEN} All $total files are identical${NC}"
else
  echo -e "${RED} $diffs of $total files differ${NC}"
  echo
  echo "Example differing files:"
  awk '$2 != $3 {print $1}' "$join_tmp" | head -n 10
  echo
  echo -e "${YELLOW}Tip:${NC} Only first 10 differing files shown."
fi

# 🧹 Cleanup
rm -f "$tmp1" "$tmp2" "$join_tmp"
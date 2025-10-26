#!/bin/bash
from_tag=$1
to_tag=$2

CHANGELOG="CHANGELOG.md"
echo "# Changelog between $from_tag and $to_tag" > "$CHANGELOG"
echo "" >> "$CHANGELOG"
echo "## Breaking Changes" >> "$CHANGELOG"
git log --pretty=format:"- %s" "$from_tag..$to_tag" | grep -E "BREAKING CHANGE:|BREAKING CHANGE\(" >> "$CHANGELOG"
echo "" >> "$CHANGELOG"
echo "## Features" >> "$CHANGELOG"
git log --pretty=format:"- %s" "$from_tag..$to_tag" | grep -E "feat:|feat\(" >> "$CHANGELOG"
echo "" >> "$CHANGELOG"
echo "## Others" >> "$CHANGELOG"
git log --pretty=format:"- %s" "$from_tag..$to_tag" | grep -E "fix:|fix\(" >> "$CHANGELOG"

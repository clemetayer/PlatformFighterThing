#!/bin/bash

function update_with_version() {
    git tag "$1";
    git tag -d "latest";
    git tag "latest";
    sed -i 's/\(config\/version="\)[^"]*\("\)/\1'"$1"'\2/' project.godot
}

latest_version_number=".."
function get_latest_version_number() {
    latest_version_number=$(git tag -l | grep -E '^[0-9]+\.[0-9]+\.[0-9]+$' | sort -V | tail -n 1)
}

bump="patch"
function compute_bump() {
    commits=$(git log --pretty=%s latest..HEAD 2>/dev/null | cat)
    while read commit; do
        echo "commit - $commit"
        if echo "$commit" | grep -qE "BREAKING CHANGE:|BREAKING CHANGE\(" > /dev/null; then
            bump="major"
        elif echo "$commit" | grep -qE "feat:|feat\(" > /dev/null && [ $bump != "major" ]; then
            bump="minor"
        fi
        echo "bump - $bump"
    done <<< "$commits"
}

new_version="0.0.1"
function compute_new_version() {
    IFS='.' read -r major minor patch <<< "$latest_version_number"
    new_major=$major
    new_minor=$minor
    new_patch=$patch
    echo "version : $latest_version_number, major : $major, minor : $minor, patch : $patch"
    if [ "$bump" = "major" ]; then
        new_major=$((major + 1))
        new_minor=0
        new_patch=0
    elif [ "$bump" = "minor" ]; then
        new_minor=$((minor + 1))
        new_patch=0
    else
        new_patch=$((patch + 1))
    fi
        echo "bump: $bump, major : $new_major, minor : $new_minor, patch : $new_patch"
    new_version="$new_major.$new_minor.$new_patch"
}

tags=$(git describe --tags --abbrev=0 2>/dev/null)
if ! [ -z "$tags" ]; then
    get_latest_version_number
    echo "latest version : $latest_version_number"
    compute_bump
    compute_new_version
fi
echo "new version : $new_version"
update_with_version $new_version

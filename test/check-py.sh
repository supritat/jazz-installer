#!/usr/bin/env bash

set -eo pipefail

bold=$(tput bold)
normal=$(tput sgr0)

# Unfortunately, the Travis docs for what TRAVIS_COMMIT_RANGE does are inaccurate
# Basically, because it uses <commit1>...<commit2> syntax, `git diff` will include
# commits made to `master` since the branch was created, which is not quite what we want.
# see https://github.com/travis-ci/travis-ci/issues/4596
# So fix here
custom_commit_range="${TRAVIS_COMMIT_RANGE/.../..}"

echo "Diffing commit range" "$custom_commit_range"

# Get changed file names, excluding deleted files
for file in $(git diff --diff-filter=d --name-only "$custom_commit_range" | grep .py\$); do
  echo "Checking ${bold}$file${normal}..."
  flake8 "$file"
done

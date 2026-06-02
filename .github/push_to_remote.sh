#!/usr/bin/env bash
set -eu
REPO_ROOT="/mnt/c/Users/appus/Downloads/github-activity-generator-main/github-activity-generator-main"
PARENT_DIR="$(dirname \"$REPO_ROOT\")"
CLONE_DIR="$PARENT_DIR/Unofficial_clone"
REMOTE="https://github.com/Pratik-sanap/Unofficial.git"
rm -rf "$CLONE_DIR" || true
git clone "$REMOTE" "$CLONE_DIR"
cd "$CLONE_DIR"
git config user.name "GitHub Actions Bot" || true
git config user.email "41898282+github-actions[bot]@users.noreply.github.com" || true
rm -rf .github || true
cp -r "$REPO_ROOT/.github" .
git add .github
if git commit -m "chore: add randomized daily commits workflow and script - tested dry-run"; then
  echo "Committed changes"
else
  echo "No changes to commit"
fi
git push origin HEAD

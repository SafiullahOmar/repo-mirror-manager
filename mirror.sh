#!/bin/bash
set -e

echo "Starting mirroring..."

repos=$(cat repos.json | jq -c '.[]')

for repo in $repos; do
  SRC=$(echo $repo | jq -r '.source')
  TGT=$(echo $repo | jq -r '.target')

  echo "Mirroring $SRC → $TGT"

  NAME=$(basename "$SRC")

  # Clone from GitHub
  git clone --mirror "https://github.com/$SRC.git"
  cd "$NAME.git"

  # Push to GitLab
  git remote set-url --push origin "https://oauth2:${GITLAB_TOKEN}@${TGT}"
  git push --mirror

  cd ..
  rm -rf "$NAME.git"
done

echo "Mirroring finished"

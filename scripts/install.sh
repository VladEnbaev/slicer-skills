#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
codex_skills_dir="${CODEX_HOME:-$HOME/.codex}/skills"

mkdir -p "$codex_skills_dir"

for skill_dir in "$repo_root"/skills/*; do
  [ -d "$skill_dir" ] || continue

  skill_name="$(basename "$skill_dir")"
  target="$codex_skills_dir/$skill_name"

  if [ -L "$target" ]; then
    rm "$target"
  elif [ -e "$target" ]; then
    echo "Refusing to overwrite non-symlink: $target" >&2
    exit 1
  fi

  ln -s "$skill_dir" "$target"
  echo "Linked $skill_name"
done

#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
python3 - <<'PY' "$repo_root"
from pathlib import Path
import re
import sys

repo_root = Path(sys.argv[1])
skills_dir = repo_root / "skills"
skill_name_pattern = re.compile(r"^[a-z0-9]+(?:-[a-z0-9]+)*$")
errors = []


def unquote(value):
    value = value.strip()
    if len(value) >= 2 and value[0] == value[-1] and value[0] in {"'", '"'}:
        return value[1:-1]
    return value


def parse_frontmatter(path):
    lines = path.read_text(encoding="utf-8").splitlines()
    if not lines or lines[0].strip() != "---":
        errors.append(f"{path}: missing YAML frontmatter")
        return {}

    end = None
    for index, line in enumerate(lines[1:], start=1):
        if line.strip() == "---":
            end = index
            break

    if end is None:
        errors.append(f"{path}: unclosed YAML frontmatter")
        return {}

    data = {}
    for line_number, line in enumerate(lines[1:end], start=2):
        stripped = line.strip()
        if not stripped or stripped.startswith("#") or line.startswith((" ", "\t")):
            continue
        if ":" not in line:
            errors.append(f"{path}:{line_number}: invalid frontmatter line")
            continue
        key, value = line.split(":", 1)
        data[key.strip()] = unquote(value)
    return data


def parse_simple_yaml(path):
    data = {}
    current_section = None

    for line_number, line in enumerate(path.read_text(encoding="utf-8").splitlines(), start=1):
        stripped = line.strip()
        if not stripped or stripped.startswith("#"):
            continue

        if line.startswith((" ", "\t")):
            if current_section is None:
                errors.append(f"{path}:{line_number}: nested key without section")
                continue
            if ":" not in stripped:
                errors.append(f"{path}:{line_number}: invalid nested YAML line")
                continue
            key, value = stripped.split(":", 1)
            data.setdefault(current_section, {})[key.strip()] = unquote(value)
            continue

        if ":" not in line:
            errors.append(f"{path}:{line_number}: invalid YAML line")
            continue
        key, value = line.split(":", 1)
        key = key.strip()
        value = value.strip()
        if value:
            data[key] = unquote(value)
            current_section = None
        else:
            data[key] = {}
            current_section = key

    return data


if not skills_dir.is_dir():
    errors.append(f"{skills_dir}: missing skills directory")

if (repo_root / "scripts" / "install.sh").exists():
    errors.append("scripts/install.sh: standalone skill installer is not allowed; expose skills through the plugin")

for skill_dir in sorted((repo_root / "skills").iterdir()):
    if not skill_dir.is_dir():
        continue
    skill_name = skill_dir.name
    if not skill_name_pattern.fullmatch(skill_name):
        errors.append(f"{skill_name}: skill directory must be lowercase hyphen-case")

    skill_md = skill_dir / "SKILL.md"
    if not skill_md.exists():
        errors.append(f"{skill_name}: missing SKILL.md")
        continue

    frontmatter = parse_frontmatter(skill_md)
    if frontmatter.get("name") != skill_name:
        errors.append(f"{skill_name}: frontmatter name must match directory name")
    if not frontmatter.get("description"):
        errors.append(f"{skill_name}: missing frontmatter description")

    metadata = skill_dir / "agents" / "openai.yaml"
    if not metadata.exists():
        errors.append(f"{skill_name}: missing agents/openai.yaml")
        continue

    data = parse_simple_yaml(metadata)
    interface = data.get("interface", {})
    for key in ("display_name", "short_description", "default_prompt"):
        if not interface.get(key):
            errors.append(f"{skill_name}: missing interface.{key}")
    if f"${skill_name}" not in interface.get("default_prompt", ""):
        errors.append(f"{skill_name}: default_prompt must mention ${skill_name}")

    if not any(error.startswith(f"{skill_name}:") or f"/{skill_name}/" in error for error in errors):
        print(f"{skill_name}: valid")

if errors:
    for error in errors:
        print(error, file=sys.stderr)
    raise SystemExit(1)
PY

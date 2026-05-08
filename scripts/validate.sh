#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
python3 - <<'PY' "$repo_root"
from pathlib import Path
import json
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


def load_json(path):
    if not path.exists():
        errors.append(f"{path}: missing JSON file")
        return {}
    try:
        return json.loads(path.read_text(encoding="utf-8"))
    except json.JSONDecodeError as exc:
        errors.append(f"{path}:{exc.lineno}:{exc.colno}: invalid JSON: {exc.msg}")
        return {}


if not skills_dir.is_dir():
    errors.append(f"{skills_dir}: missing skills directory")

if (repo_root / "scripts" / "install.sh").exists():
    errors.append("scripts/install.sh: standalone skill installer is not allowed; expose skills through agent plugins/extensions")

codex_plugin = load_json(repo_root / ".codex-plugin" / "plugin.json")
claude_plugin = load_json(repo_root / ".claude-plugin" / "plugin.json")
claude_marketplace = load_json(repo_root / ".claude-plugin" / "marketplace.json")
gemini_extension = load_json(repo_root / "gemini-extension.json")

for label, data in (
    ("codex plugin", codex_plugin),
    ("claude plugin", claude_plugin),
    ("gemini extension", gemini_extension),
):
    for key in ("name", "description", "version"):
        if not data.get(key):
            errors.append(f"{label}: missing {key}")

if codex_plugin.get("name") != claude_plugin.get("name"):
    errors.append("agent manifests: codex and claude plugin names must match")

if codex_plugin.get("version") != claude_plugin.get("version") or codex_plugin.get("version") != gemini_extension.get("version"):
    errors.append("agent manifests: versions must match")

if gemini_extension.get("contextFileName") != "GEMINI.md":
    errors.append("gemini-extension.json: contextFileName must be GEMINI.md")

if not (repo_root / "GEMINI.md").exists():
    errors.append("GEMINI.md: missing Gemini extension context file")

plugins = claude_marketplace.get("plugins", [])
if not plugins:
    errors.append("claude marketplace: missing plugins")
else:
    plugin = plugins[0]
    if plugin.get("name") != claude_plugin.get("name"):
        errors.append("claude marketplace: plugin name must match .claude-plugin/plugin.json")
    if plugin.get("version") != claude_plugin.get("version"):
        errors.append("claude marketplace: plugin version must match .claude-plugin/plugin.json")
    if plugin.get("source") != "./":
        errors.append("claude marketplace: plugin source must be ./")

skill_names = []
for skill_dir in sorted((repo_root / "skills").iterdir()):
    if not skill_dir.is_dir():
        continue
    skill_name = skill_dir.name
    skill_names.append(skill_name)
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

gemini_context = (repo_root / "GEMINI.md").read_text(encoding="utf-8") if (repo_root / "GEMINI.md").exists() else ""
for skill_name in skill_names:
    reference = f"@./skills/{skill_name}/SKILL.md"
    if reference not in gemini_context:
        errors.append(f"GEMINI.md: missing reference to {reference}")

if errors:
    for error in errors:
        print(error, file=sys.stderr)
    raise SystemExit(1)
PY

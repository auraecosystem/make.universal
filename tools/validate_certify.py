#!/usr/bin/env python3
"""Validate the make.universal certification specification.

This validator checks the certification contract itself. It deliberately does
not claim that builds, tests, CVE scans, SBOM generation, signing, or
cross-platform artifacts have passed; those require executable toolchains and
are separate certification stages.
"""

from __future__ import annotations

import argparse
import json
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
CERTIFY = ROOT / "Certify.srf"
BUILD = ROOT / "build.mu"
REPORT_DIR = ROOT / "build" / "certification"

REQUIRED_SECTIONS = {
    "certification",
    "project",
    "source",
    "build",
    "testing",
    "security",
    "artifacts",
    "reproducibility",
    "supply_chain",
    "release",
    "policy",
    "report",
    "certify",
}

REQUIRED_CERTIFY_FIELDS = {
    'name        = "make.universal"',
    'version     = "1.0.0"',
    'standard    = "make.universal"',
    'status      = "required"',
    'manifest = "build.mu"',
    'framework = "ctest"',
    'minimum = 80',
    'fail_on = "critical"',
    'format   = "spdx"',
    'command = "make certify"',
    'pass = "CERTIFIED"',
    'fail = "NOT_CERTIFIED"',
}


def section_names(text: str) -> set[str]:
    names = set()
    for match in re.finditer(r"^\s*(?:platform\s+)?(?:\"([^\"]+)\"|([A-Za-z_][A-Za-z0-9_]*))\s*\{", text, re.M):
        name = match.group(1) or match.group(2)
        if name in REQUIRED_SECTIONS:
            names.add(name)
    return names


def parse_list(text: str, key: str) -> list[str]:
    match = re.search(rf"\b{re.escape(key)}\s*=\s*\[(.*?)\]", text, re.S)
    if not match:
        return []
    return re.findall(r'"([^"]+)"', match.group(1))


def source_patterns(build_text: str) -> list[str]:
    return parse_list(build_text, "include")


def expand_pattern(pattern: str) -> list[Path]:
    return sorted(ROOT.glob(pattern))


def validate() -> tuple[bool, dict]:
    errors: list[str] = []
    warnings: list[str] = []

    if not CERTIFY.is_file():
        errors.append("Certify.srf is missing")
        return False, {"status": "NOT_CERTIFIED", "errors": errors, "warnings": warnings}

    if not BUILD.is_file():
        errors.append("build.mu is missing")
        return False, {"status": "NOT_CERTIFIED", "errors": errors, "warnings": warnings}

    certify_text = CERTIFY.read_text(encoding="utf-8")
    build_text = BUILD.read_text(encoding="utf-8")

    missing_sections = sorted(REQUIRED_SECTIONS - section_names(certify_text))
    if missing_sections:
        errors.append("Missing Certify.srf sections: " + ", ".join(missing_sections))

    for field in sorted(REQUIRED_CERTIFY_FIELDS):
        if field not in certify_text:
            errors.append(f"Missing Certify.srf field: {field}")

    manifest = re.search(r'\bmanifest\s*=\s*"([^"]+)"', certify_text)
    if manifest and manifest.group(1) != BUILD.name:
        errors.append(f"Certification manifest must be {BUILD.name!r}")

    project_name = re.search(r'\bname\s*=\s*"([^"]+)"', build_text)
    if not project_name:
        errors.append("build.mu is missing project.name")

    for key in ("version", "description", "license"):
        if not re.search(rf'\b{key}\s*=\s*"[^"]+"', build_text):
            errors.append(f"build.mu is missing project.{key}")

    patterns = source_patterns(build_text)
    if not patterns:
        errors.append("build.mu contains no source include patterns")
    else:
        for pattern in patterns:
            matches = expand_pattern(pattern)
            if not matches:
                errors.append(f"Source pattern has no matches: {pattern}")

    declared_languages = parse_list(certify_text, "languages")
    known_extensions = {
        ".c": "c",
        ".cc": "cpp",
        ".cpp": "cpp",
        ".cxx": "cpp",
        ".rs": "rust",
        ".go": "go",
        ".py": "python",
        ".js": "node",
        ".ts": "node",
        ".swift": "swift",
    }
    discovered_languages = {
        known_extensions[path.suffix.lower()]
        for path in ROOT.rglob("*")
        if path.is_file() and path.suffix.lower() in known_extensions
        and ".git" not in path.parts
        and "build" not in path.parts
    }
    undeclared = sorted(discovered_languages - set(declared_languages))
    if undeclared:
        warnings.append("Repository contains undeclared source languages: " + ", ".join(undeclared))

    result = {
        "status": "CERTIFIED" if not errors else "NOT_CERTIFIED",
        "specification": str(CERTIFY.relative_to(ROOT)),
        "manifest": str(BUILD.relative_to(ROOT)),
        "errors": errors,
        "warnings": warnings,
        "checks": {
            "sections": not missing_sections,
            "required_fields": all(field in certify_text for field in REQUIRED_CERTIFY_FIELDS),
            "manifest": bool(manifest and manifest.group(1) == BUILD.name),
            "project_metadata": all(
                re.search(rf'\b{key}\s*=\s*"[^"]+"', build_text)
                for key in ("version", "description", "license")
            ),
            "source_patterns": bool(patterns) and all(expand_pattern(p) for p in patterns),
        },
    }
    return not errors, result


def write_reports(result: dict) -> None:
    REPORT_DIR.mkdir(parents=True, exist_ok=True)
    (REPORT_DIR / "validation.json").write_text(
        json.dumps(result, indent=2) + "\n", encoding="utf-8"
    )

    sarif = {
        "$schema": "https://json.schemastore.org/sarif-2.1.0.json",
        "version": "2.1.0",
        "runs": [{
            "tool": {"driver": {"name": "make.universal Certify Validator", "version": "1.0.0"}},
            "results": [
                {
                    "ruleId": "CERTIFY",
                    "level": "error",
                    "message": {"text": error},
                    "locations": [{"physicalLocation": {"artifactLocation": {"uri": "Certify.srf"}}}],
                }
                for error in result["errors"]
            ],
        }],
    }
    (REPORT_DIR / "validation.sarif").write_text(
        json.dumps(sarif, indent=2) + "\n", encoding="utf-8"
    )


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write-report", action="store_true", help="write JSON and SARIF reports")
    args = parser.parse_args()

    ok, result = validate()
    print(f"Certify.srf: {result['status']}")
    for error in result["errors"]:
        print(f"ERROR: {error}", file=sys.stderr)
    for warning in result["warnings"]:
        print(f"WARNING: {warning}")

    if args.write_report:
        write_reports(result)
        print(f"Reports: {REPORT_DIR.relative_to(ROOT)}/")

    return 0 if ok else 1


if __name__ == "__main__":
    raise SystemExit(main())

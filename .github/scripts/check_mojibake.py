#!/usr/bin/env python3
"""Fail when Git-classified text files contain invalid UTF-8 or likely mojibake."""

from __future__ import annotations

import codecs
import os
import subprocess
import sys
from pathlib import Path

LEGACY_ENCODINGS = ("cp1252", "latin1")


def git_text_files() -> list[Path]:
    """Return non-ignored files Git classifies as text.

    Git performs the text/binary decision, so this checker does not maintain
    hardcoded extension or directory lists. .gitattributes can override Git's
    classification when the repository needs an exception.
    """
    result = subprocess.run(
        [
            "git",
            "grep",
            "--no-index",
            "--exclude-standard",
            "-I",
            "-l",
            "-z",
            "-e",
            "",
            "--",
        ],
        capture_output=True,
        check=False,
    )

    # git grep returns 1 when no files match. That is not an execution error.
    if result.returncode not in (0, 1):
        message = result.stderr.decode("utf-8", errors="replace").strip()
        raise RuntimeError(f"git grep failed: {message}")

    return [
        Path(os.fsdecode(raw_path))
        for raw_path in result.stdout.split(b"\0")
        if raw_path
    ]


def utf8_sequence_length(first_byte: int) -> int:
    """Return the expected UTF-8 sequence length for a valid lead byte."""
    if 0xC2 <= first_byte <= 0xDF:
        return 2
    if 0xE0 <= first_byte <= 0xEF:
        return 3
    if 0xF0 <= first_byte <= 0xF4:
        return 4
    return 0


def repair_candidate(
    text: str,
    index: int,
    legacy_encoding: str,
) -> tuple[str, str] | None:
    """Return a likely mojibake segment and its repaired form, if one exists."""
    try:
        lead_bytes = text[index].encode(legacy_encoding)
    except UnicodeEncodeError:
        return None

    if len(lead_bytes) != 1:
        return None

    length = utf8_sequence_length(lead_bytes[0])
    if length == 0 or index + length > len(text):
        return None

    segment = text[index : index + length]

    try:
        raw_bytes = segment.encode(legacy_encoding)
        repaired = raw_bytes.decode("utf-8")
    except (UnicodeEncodeError, UnicodeDecodeError):
        return None

    if repaired == segment:
        return None

    return segment, repaired


def find_mojibake(text: str) -> tuple[str, str] | None:
    """Find the first reversible UTF-8-as-legacy-encoding sequence."""
    for index in range(len(text)):
        for encoding in LEGACY_ENCODINGS:
            candidate = repair_candidate(text, index, encoding)
            if candidate is not None:
                return candidate

    return None


def escaped(value: str) -> str:
    """Return an ASCII-safe representation for CI logs."""
    return value.encode("unicode_escape").decode("ascii")


def check_file(path: Path) -> list[str]:
    failures: list[str] = []

    try:
        data = path.read_bytes()
    except OSError as error:
        return [f"{path}: unable to read file: {error}"]

    if data.startswith(codecs.BOM_UTF8):
        failures.append(f"{path}: UTF-8 BOM found; use UTF-8 without BOM")

    try:
        text = data.decode("utf-8")
    except UnicodeDecodeError as error:
        return [f"{path}: invalid UTF-8 at byte {error.start}"]

    for line_number, line in enumerate(text.splitlines(), start=1):
        if "\ufffd" in line:
            failures.append(
                f"{path}:{line_number}: Unicode replacement character found"
            )
            continue

        if any(0x0080 <= ord(char) <= 0x009F for char in line):
            failures.append(
                f"{path}:{line_number}: unexpected C1 control character found"
            )
            continue

        # UTF-8 BOM bytes rendered as visible Latin-1/Windows-1252 text.
        if "\u00ef\u00bb\u00bf" in line:
            failures.append(f"{path}:{line_number}: rendered UTF-8 BOM mojibake found")
            continue

        candidate = find_mojibake(line)
        if candidate is None:
            continue

        broken, repaired = candidate
        failures.append(
            f"{path}:{line_number}: possible mojibake "
            f"{escaped(broken)} -> {escaped(repaired)}"
        )

    return failures


def main() -> int:
    try:
        files = git_text_files()
    except RuntimeError as error:
        print(f"ERROR: {error}", file=sys.stderr)
        return 2

    failures: list[str] = []

    for path in files:
        if path.is_file():
            failures.extend(check_file(path))

    if failures:
        print("Mojibake / UTF-8 check failed:", file=sys.stderr)
        for failure in failures:
            print(f"  {failure}", file=sys.stderr)
        return 1

    print(
        f"PASS: {len(files)} Git-classified text files are valid UTF-8 "
        "with no detected mojibake."
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

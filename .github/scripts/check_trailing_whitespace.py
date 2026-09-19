#!/usr/bin/env python3
"""Check or safely repair trailing whitespace for the repository."""

from __future__ import annotations

import argparse
from dataclasses import dataclass
from pathlib import Path
import re
import subprocess
import sys

FIXED_RESTAGE_REQUIRED = 3
UNSAFE_TO_FIX = 4

TRAILING_ERROR = re.compile(r"^(.*):(\d+): trailing whitespace\.$")
TRAILING = re.compile(rb"[ \t]+$")
FENCE = re.compile(rb"^[ \t]{0,3}(`{3,}|~{3,})")


@dataclass(frozen=True)
class PlannedFix:
    path: Path
    repaired: bytes


def run_git(*args: str, check: bool = True) -> subprocess.CompletedProcess[bytes]:
    result = subprocess.run(
        ["git", *args],
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        check=False,
    )

    if check and result.returncode != 0:
        message = result.stderr.decode("utf-8", errors="replace").strip()
        raise RuntimeError(f"git {' '.join(args)} failed: {message}")

    return result


def split_eol(line: bytes) -> tuple[bytes, bytes]:
    if line.endswith(b"\r\n"):
        return line[:-2], b"\r\n"
    if line.endswith(b"\n") or line.endswith(b"\r"):
        return line[:-1], line[-1:]
    return line, b""


def preferred_eol(data: bytes) -> bytes:
    if b"\r\n" in data:
        return b"\r\n"
    if b"\n" in data:
        return b"\n"
    if b"\r" in data:
        return b"\r"
    return b"\n"


def is_markdown(path: Path) -> bool:
    return path.suffix.lower() in {".md", ".markdown"}


def stripped_for_compare(data: bytes) -> bytes:
    """Ignore only line endings and trailing spaces/tabs for safety checks."""
    output: list[bytes] = []

    for line in data.splitlines(keepends=True):
        body, _ = split_eol(line)
        body = TRAILING.sub(b"", body)
        output.append(body + b"\n")

    if data and not data.endswith((b"\n", b"\r")):
        output[-1] = output[-1][:-1]

    return b"".join(output)


def repair_from_staged(
    path: Path,
    staged: bytes,
    eol: bytes,
) -> tuple[bytes, list[int]]:
    """Build a clean working-tree version from the staged blob.

    Markdown:
    - two or more trailing ASCII spaces outside a fenced block become a
      backslash hard break;
    - one trailing space or trailing tabs are removed;
    - trailing whitespace inside fenced code blocks is treated as ambiguous.

    Other text:
    - trailing spaces/tabs are removed.
    """
    markdown = is_markdown(path)
    in_fence = False
    fence_char: bytes | None = None
    fence_size = 0
    ambiguous: list[int] = []
    output: list[bytes] = []

    lines = staged.splitlines(keepends=True)

    for number, line in enumerate(lines, start=1):
        body, original_eol = split_eol(line)
        fence_match = FENCE.match(body)

        if markdown and fence_match is not None:
            marker = fence_match.group(1)
            char = marker[:1]
            size = len(marker)

            if not in_fence:
                in_fence = True
                fence_char = char
                fence_size = size
            elif char == fence_char and size >= fence_size:
                in_fence = False
                fence_char = None
                fence_size = 0

        match = TRAILING.search(body)

        if match is not None:
            whitespace = match.group(0)
            core = body[: match.start()]

            if markdown and in_fence:
                ambiguous.append(number)
            elif (
                markdown
                and b"\t" not in whitespace
                and len(whitespace) >= 2
                and not core.endswith(b"\\")
            ):
                body = core + b"\\"
            else:
                body = core

        output.append(body + (eol if original_eol else b""))

    return b"".join(output), ambiguous


def git_text_files() -> list[Path]:
    result = run_git(
        "grep",
        "--no-index",
        "--exclude-standard",
        "-I",
        "-l",
        "-z",
        "-e",
        "",
        "--",
        check=False,
    )

    if result.returncode not in (0, 1):
        message = result.stderr.decode("utf-8", errors="replace").strip()
        raise RuntimeError(f"git grep failed: {message}")

    return [
        Path(raw.decode(sys.getfilesystemencoding(), errors="surrogateescape"))
        for raw in result.stdout.split(b"\0")
        if raw
    ]


def trailing_lines(data: bytes) -> list[int]:
    failures: list[int] = []

    for number, line in enumerate(data.splitlines(keepends=True), start=1):
        body, _ = split_eol(line)
        if TRAILING.search(body) is not None:
            failures.append(number)

    return failures


def check_all() -> int:
    failures: list[str] = []

    for path in git_text_files():
        if not path.is_file():
            continue

        try:
            data = path.read_bytes()
        except OSError as error:
            failures.append(f"{path}: unable to read file: {error}")
            continue

        for line_number in trailing_lines(data):
            failures.append(f"{path}:{line_number}: trailing whitespace")

    if failures:
        print("Trailing-whitespace check failed:", file=sys.stderr)
        for failure in failures:
            print(f"  {failure}", file=sys.stderr)
        return 1

    print("PASS: Git-visible text files contain no trailing whitespace.")
    return 0


def staged_trailing_paths() -> list[Path]:
    result = run_git("diff", "--cached", "--check", check=False)

    if result.returncode == 0:
        return []

    output = result.stdout.decode("utf-8", errors="replace")
    paths: list[Path] = []
    seen: set[str] = set()

    for line in output.splitlines():
        match = TRAILING_ERROR.match(line)
        if match is None:
            continue

        raw_path = match.group(1)

        if raw_path not in seen:
            seen.add(raw_path)
            paths.append(Path(raw_path))

    if not paths:
        raise RuntimeError(
            "git diff --cached --check failed for a reason other than "
            "parseable trailing whitespace"
        )

    return paths


def staged_bytes(path: Path) -> bytes | None:
    result = run_git("show", f":{path.as_posix()}", check=False)

    if result.returncode != 0:
        return None

    return result.stdout


def plan_fixes(paths: list[Path]) -> tuple[list[PlannedFix], list[str]]:
    plans: list[PlannedFix] = []
    unsafe: list[str] = []

    for path in paths:
        if not path.is_file():
            unsafe.append(f"{path}: working-tree file is missing")
            continue

        staged = staged_bytes(path)
        if staged is None:
            unsafe.append(f"{path}: staged blob is unavailable")
            continue

        try:
            working = path.read_bytes()
        except OSError as error:
            unsafe.append(f"{path}: unable to read working tree: {error}")
            continue

        if stripped_for_compare(staged) != stripped_for_compare(working):
            unsafe.append(f"{path}: contains substantive unstaged changes")
            continue

        repaired, ambiguous = repair_from_staged(
            path,
            staged,
            preferred_eol(working),
        )

        if ambiguous:
            line_list = ", ".join(str(number) for number in ambiguous)
            unsafe.append(
                f"{path}: trailing whitespace inside fenced Markdown code "
                f"block at line(s) {line_list}"
            )
            continue

        plans.append(PlannedFix(path=path, repaired=repaired))

    return plans, unsafe


def fix_staged() -> int:
    paths = staged_trailing_paths()

    if not paths:
        print("PASS: staged diff contains no trailing whitespace.")
        return 0

    plans, unsafe = plan_fixes(paths)

    # Atomic refusal: if any file is unsafe, change none of the affected files.
    if unsafe:
        print(
            "Refused automatic repair because safety could not be proven for "
            "every staged file:",
            file=sys.stderr,
        )
        for reason in unsafe:
            print(f"  {reason}", file=sys.stderr)
        return UNSAFE_TO_FIX

    changed: list[Path] = []
    already_clean: list[Path] = []

    for plan in plans:
        current = plan.path.read_bytes()

        if current == plan.repaired:
            already_clean.append(plan.path)
            continue

        plan.path.write_bytes(plan.repaired)
        changed.append(plan.path)

    if changed:
        print("Safely repaired trailing whitespace in the working tree:")
        for path in changed:
            print(f"  {path}")

    if already_clean:
        print("Working tree was already repaired; re-stage is still required:")
        for path in already_clean:
            print(f"  {path}")

    print(
        "The Git index was not modified. Inspect and re-stage the listed files, "
        "then retry the commit."
    )
    return FIXED_RESTAGE_REQUIRED


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Check or safely repair trailing whitespace."
    )
    parser.add_argument(
        "--fix-staged",
        action="store_true",
        help=(
            "Safely repair staged trailing-whitespace issues in the working "
            "tree. Never modifies the Git index."
        ),
    )
    return parser.parse_args()


def main() -> int:
    args = parse_args()

    try:
        return fix_staged() if args.fix_staged else check_all()
    except RuntimeError as error:
        print(f"ERROR: {error}", file=sys.stderr)
        return 2


if __name__ == "__main__":
    raise SystemExit(main())
#!/usr/bin/env python3
"""
agenda.py - Pull a due-date agenda out of todo.txt-style markdown checkboxes.

Recognizes lines like:
  - [ ] (A) due:2026-07-08 [[fleet]] discuss the following points
  - [x] understand what needs to change (done:2026-07-01)

Usage:
  agenda.py work.md personal.md
  agenda.py work.md --after 2026-07-07 --before 2026-07-12
  agenda.py work.md --status open
  agenda.py work.md --status done
"""

from typing import TypedDict
import argparse
import re
import sys
from collections import defaultdict
from datetime import date as date_cls, timedelta

TASK_RE = re.compile(r"^\s*-\s*\[( |x|X)\]\s*(.*)$")
PRIORITY_RE = re.compile(r"\(([A-C])\)")
DUE_RE = re.compile(r"due:(\d{4}-\d{2}-\d{2})")
DONE_RE = re.compile(r"done:(\d{4}-\d{2}-\d{2})")


class TaskObject(TypedDict):
    file: str
    line: int | None
    date: str  # keeping it isodate for now
    priority: str | None
    text: str
    done: bool


def parse_file(path: str) -> list[TaskObject]:
    tasks = []
    with open(path, encoding="utf-8") as f:
        for lineno, line in enumerate(f, 1):
            m = TASK_RE.match(line)
            if not m:
                continue
            checked = m.group(1).lower() == "x"
            rest = m.group(2)

            due_m = DUE_RE.search(rest)
            done_m = DONE_RE.search(rest)
            date = due_m.group(1) if due_m else (done_m.group(1) if done_m else None)
            if not date:
                continue

            pr_m = PRIORITY_RE.search(rest)
            priority = pr_m.group(1) if pr_m else None

            text = rest
            text = DUE_RE.sub("", text)
            text = DONE_RE.sub("", text)
            text = PRIORITY_RE.sub("", text)
            text = re.sub(r"\s+", " ", text).strip(" ()")

            tasks.append(
                TaskObject(
                    {
                        "file": path,
                        "line": lineno,
                        "done": checked,
                        "date": date,
                        "priority": priority,
                        "text": text,
                    }
                )
            )
    return tasks


def main():
    ap = argparse.ArgumentParser(description="Agenda from due:/done: tagged markdown checkboxes")
    ap.add_argument("files", nargs="+")
    ap.add_argument("--after", help="only show dates >= this (YYYY-MM-DD)")
    ap.add_argument("--before", help="only show dates <= this (YYYY-MM-DD)")
    ap.add_argument("--status", choices=["open", "done"], help="filter by status")
    args = ap.parse_args()

    all_tasks = []
    for path in args.files:
        try:
            all_tasks.extend(parse_file(path))
        except FileNotFoundError:
            print(f"warning: {path} not found", file=sys.stderr)

    if args.after:
        all_tasks = [t for t in all_tasks if t["date"] >= args.after]
    if args.before:
        all_tasks = [t for t in all_tasks if t["date"] <= args.before]
    if args.status == "open":
        all_tasks = [t for t in all_tasks if not t["done"]]
    elif args.status == "done":
        all_tasks = [t for t in all_tasks if t["done"]]

    by_date = defaultdict(list)
    for t in all_tasks:
        by_date[t["date"]].append(t)

    if not by_date:
        print("No dated tasks found.")
        return
    today = date_cls.today()
    today_str = today.isoformat()

    for i in range(-7, 0):
        date = (today + timedelta(days=i)).isoformat()
        if len(by_date[date]) > 0:
            weekday = date_cls.fromisoformat(date).strftime("%A")
            label = f"{date} ({weekday})"
            print(f"\n{label}")
            print("-" * len(label))
            for t in sorted(by_date[date], key=lambda x: (x["done"], x["priority"] or "Z")):
                box = "x" if t["done"] else " "
                priority = f"({t['priority']}) " if t["priority"] else ""
                short_file = t["file"].split("/")[-1]
                tag = "#Daily" if "daily" in short_file else "#Work"
                print(f"  [{box}] ({tag}) {priority}{t['text']}  ({short_file}:{t['line']})")

    for i in range(7):
        date = (today + timedelta(days=i)).isoformat()
        weekday = date_cls.fromisoformat(date).strftime("%A")
        label = f"{date} ({weekday})"
        if date == today_str:
            label += "  <-- TODAY"
        print(f"\n{label}")
        print("-" * len(label))
        for t in sorted(by_date[date], key=lambda x: (x["done"], x["priority"] or "Z")):
            box = "x" if t["done"] else " "
            priority = f"({t['priority']}) " if t["priority"] else ""
            short_file = t["file"].split("/")[-1]
            tag = "#Daily" if "daily" in short_file else "#Work"
            print(f"  [{box}] ({tag}) {priority}{t['text']}  ({short_file}:{t['line']})")


if __name__ == "__main__":
    main()

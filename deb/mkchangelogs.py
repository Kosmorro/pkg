import sys
import re
import datetime
import time
import textwrap

from argparse import ArgumentParser
from email import utils

def main() -> int:
    args = ArgumentParser(description="Generate a Debian-compatible changelog from a Markdown changelog file")
    args.add_argument("package", type=str)
    args.add_argument("maintainer_name", type=str)
    args.add_argument("maintainer_email", type=str)
    args = args.parse_args()

    started_list = False
    change_lines = []
    version = None
    date = None

    for line in sys.stdin:
        markdown_line = line.strip()
        if not started_list:
            started_list = markdown_line.startswith(("* ", "- "))
            if not started_list:
                if version is None and date is None and markdown_line.startswith(("# ", "## ")):
                    m = re.findall(r"(\d+\.\d+\.\d+).*\((\d+-\d+-\d+)\)$", markdown_line)
                    if len(m) == 1:
                        version, date = m[0]
                        date = datetime.datetime.fromisoformat(date)
                        date = utils.formatdate(float(date.strftime("%s")), localtime=True)

                continue

        if not markdown_line.startswith(("* ", "- ")):
            break

        for l in textwrap.wrap(markdown_line, width=78):
            change_lines.append(textwrap.indent(l, "  "))

    print(f"{args.package} ({version}) all; urgency=medium")
    print()
    print("\n".join(change_lines))
    print()
    print(f" -- {args.maintainer_name} <{args.maintainer_email}>  {date}")

    return 0


if __name__ == "__main__":
    exit(main())

#!/usr/bin/env python
# bootstrap.py
# Bootstrap and setup a virtualenv with the specified requirements.txt
import os
import sys
import shutil
import subprocess
from optparse import OptionParser


usage = """usage: %prog [options]"""
parser = OptionParser(usage=usage)
parser.add_option("-c", "--clear", dest="clear", action="store_true",
                  help="clear out existing virtualenv")
parser.add_option("-u", "--upgrade", dest="upgrade", action="store_true",
                  help="Upgrade")

def main():
    if "VIRTUAL_ENV" not in os.environ:
        sys.stderr.write("$VIRTUAL_ENV not found.\n\n")
        parser.print_usage()
        sys.exit(-1)
    (options, pos_args) = parser.parse_args()
    virtualenv = os.environ["VIRTUAL_ENV"]
    if options.clear:
        subprocess.call(["virtualenv", "--clear", "--distribute", virtualenv])
    file_path = os.path.dirname(__file__)

    pip_args = ["pip"]

    if 'HTTP_PROXY' in os.environ:
        pip_args.append("--proxy='" + os.environ['HTTP_PROXY'] + "'")

    pip_args.extend(["install", "-E", virtualenv, "--requirement",
        os.path.join(file_path, "requirements.txt")])

    if options.upgrade:
        pip_args.append("--upgrade")

    subprocess.call(pip_args)


if __name__ == "__main__":
    main()
    sys.exit(0)

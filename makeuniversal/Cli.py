# cli.py
import sys
from core import create_project, deploy_project

def help_menu():
    print("""
makeuniversal CLI

Commands:
  create <name>
  deploy <name>
""")

if __name__ == "__main__":
    args = sys.argv

    if len(args) < 2:
        help_menu()
        exit()

    cmd = args[1]

    if cmd == "create":
        create_project(args[2])

    elif cmd == "deploy":
        deploy_project(args[2])

    else:
        help_menu()

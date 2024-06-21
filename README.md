# execs

A bash script that hooks potentially dangerous commands to review their
execution.

## Setup

Include in your bashrc file the following environment variable:

```bash
# Example list of dangerous commands

EXECS_HOOKS=(
    "chmod -R"
    "chown -R"
    "cp"
    "dd"
    "mv"
    "rm -rf"
    "sudo"
)
```

Then you'll need to source the execs script to complete the setup:

```bash
source execs.sh
```

## How it works

Execs checks that the command input by the user in the bash session doesn't
start with a pattern defined in the EXECS_HOOKS environment variable.
If a command is detected as dangerous then execs will prompt the user for
confirmation before actually executing the command.

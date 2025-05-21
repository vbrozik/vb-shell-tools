# vb-shell-tools

Repository various simple shell tools for common use: backups etc.

Install the tools by running `./setup.sh`. NOTE: Currently only scripts
are installed.

## backup

Create a backup of specified files and directories to tar archive
in specified directories. The tool keeps defined number of backups
(3 by default) and deletes the oldest ones.

## functions and aliases

### wsl-tools

- `cdw` --- change directory to Windows path

### python-tools

- `debugpyw` --- run Python debugpy in wait mode (for debugging in VS Code)
  - supports: executable file path, `-m` *`module`*, executable in `$PATH`
    (e.g. venv entry point)

Example of VS Code `launch.json` profile to be added:

``` json
        {
            "name": "Python: debugpyw",
            "type": "python",
            "request": "attach",
            "connect": {
                "host": "localhost",
                "port": 5678
            }   
        }
```

### various

This section contains various tools. They are not included in the default
installation.

## Scripts in other repositories

Some of my other repositories contain shell scripts usable in generic systems. They might be moved here in the future.

- [cp-sh-tools](https://github/com/vbrozik/cp-sh-tools) - shell tools for Check Point Gaia
  - [bgjob](https://github.com/vbrozik/cp-sh-tools/blob/main/generic/bgjob) - run background job easily without `screen` or `tmux`
  - [watch_diff](https://github.com/vbrozik/cp-sh-tools/blob/main/generic/watch_diff) - watch for changes in repeated runs of a command and log them

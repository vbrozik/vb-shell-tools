# TODO

## Add tools

- KeeAgent helper
- ssh tools
- keep first lines (for grep etc.)
  - <https://stackoverflow.com/questions/9969414/always-include-first-line-in-grep>
- Python
  - `venvact` - activate venv in `.venv` by default
  - `venvdup` - duplicate venv
  - `venvinit` - initialize venv `.venv` by default, update `pip` and `setuptools`, install `requirements.txt`
  - automatically number new venvs
- Shell tools
  - `promptanon` - anonymize prompt remove `\u@\h` and following `:`
  - `promptrestore`
- escape shell code for example for `watch`

## Add functionality

- setup.sh
  - install functions and aliases
- add bash completion

## Inspiration

- `.bashrc.d` - <https://github.com/detro/.bashrc.d>
  - `/etc/profile.d/` exists: <https://unix.stackexchange.com/questions/493224/how-can-i-make-my-script-in-etc-profile-d-to-run-after-all-other-scripts-in-sam>
- `less` syntax highlighting and formatting
  - default `-R` option ?
  - YAML: `LESSOPEN="|yq -PC %s" less -R ...`
  - <https://unix.stackexchange.com/questions/90990/less-command-and-syntax-highlighting>
  - <https://unix.stackexchange.com/questions/191487/how-to-chain-multiple-lessopen-scripts>
  - <https://unix.stackexchange.com/questions/267361/syntax-highlighting-in-the-terminal>

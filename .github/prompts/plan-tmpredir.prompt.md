# Plan: Bash `=(command)` Substitution Emulator

Implement a bash script (`tmpredir`) that emulates zsh's `=(command)` process substitution by capturing command outputs into temporary files, passing their paths to a main command, and cleaning up afterward. This enables tools requiring seekable files (e.g., `diff`, `file`) to work with dynamic command outputs.

## Steps

1. **Define placeholder syntax** in [tmpredir](scripts/system/tmpredir): Use `%identifier` markers in the command line to indicate where temp file paths should be substituted. This avoids shell metacharacter conflicts and is visually distinct. The identifier would normally
be the ordinal number of the `<(command)` substitution, e.g., `%1`, `%2`, etc.

2. **Parse arguments**: The full CLI syntax would be:
   ```bash
   tmpredir [-options] [input_file1 input_file2 ...] -- main_command arg1 arg2 ...
   ```
   where `input_fileX` would usually be `<(command)` substitution, and `argX` can contain `%identifier` placeholders for these inputs.

3. **Copy inputs to temp files**: For each input file (typically a `<(command)` process substitution), create a unique temp file via `mktemp /tmp/tmpredir.XXXXXX` and copy the content into it. Store the temp file paths in an indexed array corresponding to `%1`, `%2`, etc.

4. **Substitute placeholders with file paths**: Iterate through the main command arguments and replace each `%N` placeholder with the corresponding temp file path from the array.

5. **Execute main command and cleanup**: Run the assembled command, then use `trap cleanup EXIT` to remove all temp files regardless of exit status (following the workspace's [eth_stats](scripts/net_diag/eth_stats) pattern).

## Further Considerations

* **Error handling strategy**: The script should abort with clear error message if an inner command fails.

* **Future output redirection**: In the future the script should also accept `>(command)` arguments for output redirection. It should detect the direction of the substitution automatically.

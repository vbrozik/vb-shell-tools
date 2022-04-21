#!/bin/sh

#region wsl-tools --- Tools for WSL (Windows Subsystem for Linux)

# TODO:
# - pwdw --- print current directory in Windows path

cdw () {
        # cd to Windows directory
        # FIXME: Descirbe how to share the $USERPROFILE variable from Windows.
        if test "$#" -eq 0 ; then
                cd -- "$USERPROFILE" || return
        elif test "$1" = - ; then
                cd - || return
        else
                cd -- "$(wslpath "$@")" || return
        fi
}

#endregion wsl-tools

#!/bin/sh

# Requirements:
# - wslpath --- installed in the default WSL Ubuntu 20.04


#region wsl-tools --- Tools for WSL (Windows Subsystem for Linux)

# TODO:
# - pwdw --- print current directory as Windows path

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

#!/bin/sh

# Requirements:

# - wslpath --- installed in the default WSL Ubuntu 20.04 and newer

# - configure export of %USERPROFILE% Windows environment varible to
#   $USERPROFILE - run this command in Windows for permanent setting:
#   setx WSLENV "${env:WSLENV}:USERPROFILE/up"
#   # does not work right: https://github.com/microsoft/terminal/issues/7130
#   setx WSLENV USERPROFILE/up

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

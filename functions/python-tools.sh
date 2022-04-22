#!/bin/sh

#region python-tools --- Tools for Python development

debugpyw () {
        # Start debugpy in wait mode for VS Code remote debugging
        _program="$1"
        shift
        if ! test -f "$_program" ; then
                _program="$(which "$_program")"
        fi
        python -m debugpy --listen 5678 --wait-for-client "$_program" "$@"
        unset _program
}

alias venvactivate='. .venv/bin/activate'

#endregion python-tools

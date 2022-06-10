#!/bin/sh

# vb-shell-tools

# Requirements:
# - debugpy --- Microsoft's Python debugger: pip install debugpy

python_vergte() {
        # Check if python version is greater than or equal to $1
        vergte "$("${2:-python3}" -V | awk '{print $2}')" "$1"
}

debugpyw () {
        # Start debugpy in wait mode for VS Code remote debugging
        # FIXME: Describe debug profile in VS Code creation
        _program="$1"
        shift
        if ! test -f "$_program" ; then
                _program="$(which "$_program")"
        fi
        python -m debugpy --listen 5678 --wait-for-client "$_program" "$@"
        unset _program
}

venvact () {
        # Activate virtual environment, by default .venv
        # Usage: venv_act [virtualenv_dir]
        # Example: venv_act venv_abc
        _venv="${1:-.venv}"
        if ! test -r "$_venv/bin/activate" ; then
                echo "ERROR: Virtual environment $_venv not found"
                unset _venv
                return 1
        fi
        # shellcheck source=/dev/null
        . "$_venv/bin/activate"
        unset _venv
}

venvinit () {
        # Create virtual environment, by default .venv, update it, and activate it
        # Usage: venv_init [-R] [virtualenv_dir]
        # Example: venv_init venv_abc
        unset _noreq
        if test "$1" = -R ; then
                _noreq=true
                shift
        fi
        _venv="${1:-.venv}"
        if test -d "$_venv" ; then
                echo "ERROR: Virtual environment $_venv already exists"
                unset _venv _noreq
                return 1
        fi
        if python_vergte 3.9 ; then
                echo Python 3.9+ detected, using --upgrade-deps
                python3 -m venv --upgrade-deps "$_venv"
        else
                python3 -m venv "$_venv"
                "$_venv/bin/python" -m pip install -U pip
                "$_venv/bin/python" -m pip install -U setuptools
        fi
        venvact "$_venv"
        pip install -U wheel
        if test -r requirements.txt -a -z "$_noreq" ; then
                pip install -r requirements.txt
        fi
        unset _venv _noreq
}

venvdup () {
        # Duplicate virtual environment, by default .venv and activate it
        # Usage: venv_dup [src_virtualenv_dir] dst_virtualenv_dir
        # Example: venv_dup venv_abc venv_def
        _src_venv=.venv
        if test $# -ge 2 ; then
                _src_venv="${1:-.venv}"
                shift
        fi
        if ! test -r "$_src_venv/bin/activate" ; then
                echo "ERROR: Virtual environment $_src_venv not found"
                unset _src_venv
                return 1
        fi
        _dst_venv="${_src_venv}_dup"    # TODO auto-numbering
        if test -d "$_dst_venv" ; then
                echo "ERROR: Virtual environment $_dst_venv already exists"
                unset _src_venv _dst_venv
                return 1
        fi
        venvinit -R "$_dst_venv"
        "$_src_venv/bin/python" -m pip freeze |
                grep -v '^pkg_resources==0\.0\.0' > "$_dst_venv/requirements_dup.txt"
        pip install -r "$_dst_venv/requirements_dup.txt"
        unset _src_venv _dst_venv
}

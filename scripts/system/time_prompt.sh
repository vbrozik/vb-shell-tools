#!/bin/bash

# This code is to be sourced in a shell to modify the prompt.

# This code modifies the shell prompt to be on a separate line with
# the comment symbol # preceding it. It also adds a timestamp to the prompt.
# Additionally, time is also displayed just before the entered command
# is to be executed.

# The prompts are designed so that they do not interfere with the commands
# when pasted into the shell to be executed.

# Notes:
# Since bash 5.1 $PROMPT_COMMAND can be an array

if [ "$1" = "restore" ]; then
    test -n "$PROMPT_COMMAND_SAVE_ARRAY" && PROMPT_COMMAND=("${PROMPT_COMMAND_SAVE_ARRAY[@]}")
    unset PROMPT_COMMAND_SAVE_ARRAY
    # shellcheck disable=SC2178,SC2128  # here $PROMPT_COMMAND is not an array
    test -n "$PROMPT_COMMAND_SAVE" && PROMPT_COMMAND="$PROMPT_COMMAND_SAVE"
    unset PROMPT_COMMAND_SAVE

    if test -n "$TRAP_DEBUG_SAVE" ; then
        # Trap unsetting does not work in a sourced script.
        # As a workaround we unset the trap from within $PROMPT_COMMAND
        if declare -p PROMPT_COMMAND 2>/dev/null | grep -q 'declare -a' ; then
            # shellcheck disable=SC2016     # We do not want to expand the variables here.
            PROMPT_COMMAND=(
                "_trap_debug_print_bypass= $TRAP_DEBUG_SAVE"
                "${PROMPT_COMMAND[@]}"
                'PROMPT_COMMAND=("${PROMPT_COMMAND[@]:1:$((${#PROMPT_COMMAND[@]} - 2))}")'
                )
        else
            # TODO: Test if this works
            # shellcheck disable=SC2178,SC2128  # here $PROMPT_COMMAND is not an array
            PROMPT_COMMAND="$PROMPT_COMMAND ; $TRAP_DEBUG_SAVE ; PROMPT_COMMAND=\${PROMPT_COMMAND% ; \$TRAP_DEBUG_SAVE ; PROMPT_COMMAND=*}"
        fi
    fi
    unset TRAP_DEBUG_SAVE
    test -n "$PS1_SAVE" && PS1="$PS1_SAVE"
    unset PS1_SAVE
    test -n "$PS2_SAVE" && PS2="$PS2_SAVE"
    unset PS2_SAVE
    test -n "$PS3_SAVE" && PS3="$PS3_SAVE"
    unset PS3_SAVE
    test -n "$PS4_SAVE" && PS4="$PS4_SAVE"
    unset PS4_SAVE

    return
fi

# Save the current prompts and PROMPT_COMMAND.
PS1_SAVE=$PS1
PS2_SAVE=$PS2
PS3_SAVE=$PS3
PS4_SAVE=$PS4

if declare -p PROMPT_COMMAND 2>/dev/null | grep -q 'declare -a' ; then
    PROMPT_COMMAND_SAVE_ARRAY=("${PROMPT_COMMAND[@]}")
else
    # shellcheck disable=SC2178,SC2128  # here $PROMPT_COMMAND is not an array
    PROMPT_COMMAND_SAVE="$PROMPT_COMMAND"
fi

prompt_time () {
    date +%T.%3N
}

# Set the prompt to be on a separate line with the comment symbol # preceding it.
PS1="\n# \$(prompt_time) $PS1\n"
PS2=""
PS4="# \$(prompt_time) $PS4\n"

# Set trap DEBUG to display the time before the command is executed.
_trap_debug_print_bypass=
trap_debug_print () {
    if [[ "$BASH_COMMAND" != *'_trap_debug_print_bypass='* ]] &&
        [[ -z "$_trap_debug_print_bypass" ]] ; then
        printf "# %s %s\n\n" "$(prompt_time)" "$BASH_COMMAND"
    fi
}

if [ -n "$PROMPT_COMMAND" ] ; then  # FIXME: Fix for arrays
    if declare -p PROMPT_COMMAND 2>/dev/null | grep -q 'declare -a' ; then
        for i in "${!PROMPT_COMMAND[@]}" ; do
            PROMPT_COMMAND[i]="_trap_debug_print_bypass=1 ; ${PROMPT_COMMAND[i]} ; _trap_debug_print_bypass="
        done
    else
        # shellcheck disable=SC2178,SC2128  # here $PROMPT_COMMAND is not an array
        PROMPT_COMMAND="_trap_debug_print_bypass=1 ; $PROMPT_COMMAND ; _trap_debug_print_bypass="
    fi
fi

TRAP_DEBUG_SAVE=$(trap -p DEBUG)
if [ -z "$TRAP_DEBUG_SAVE" ] ; then
    TRAP_DEBUG_SAVE="trap - DEBUG"
fi
trap trap_debug_print DEBUG

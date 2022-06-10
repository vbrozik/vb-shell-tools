# start ~/.bashrc.d reader  # when removing, remove from start to end
# shellcheck source=/dev/null
test -r "${HOME}/.bashrc.d/_init.sh" && . "${HOME}/.bashrc.d/_init.sh"
# end ~/.bashrc.d reader

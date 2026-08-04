#!/bin/sh

# rfc7468_to_single_line.sh
# Convert RFC7468 (PEM) files to a single-line format.

# The tool is useful for example when you want to include a PEM file in a JSON string.

# Without options the output will be a single line with the BEGIN and END lines separated
# by a space.
#  - This is probably the most compatible single line modification of the RFC7468 format.
#  - Note that it is not a valid RFC7468 format, but it is often being accepted.
# With the -e option the output will have newlines replaced with \n escape sequences.
#  - This is the standard multiline encoding for a JSON string.


begin_separator=' '
end_separator=' '
data_separator=''

for arg in "$@" ; do
    case "$arg" in
        -e)
            begin_separator='\\n'
            end_separator=''
            data_separator='\\n'
            ;;
        -h|--help)
            echo "Usage: $0 [-e] [input_file]"
            exit 0
            ;;
        --)
            shift
            break
            ;;
        -)
            break
            ;;
        -*)
            echo "Unknown option: $arg" >&2
            exit 1
            ;;
        *)
            break
            ;;
    esac
    shift
done

if [ "$#" -eq 0 ] ; then
    input_file=-
elif [ "$#" -eq 1 ] ; then
    input_file="$1"
else
    echo "See $0 -h for usage. Unexpected number of arguments: $#" >&2
    exit 1  
fi

begin_separator=$begin_separator \
end_separator=$end_separator \
data_separator=$data_separator \
awk '
    BEGIN {
        begin_separator = ENVIRON["begin_separator"]
        end_separator = ENVIRON["end_separator"]
        data_separator = ENVIRON["data_separator"]
    }
    /^-{3,}BEGIN [A-Z ]+-{3,}$/ { printf "%s%s", $0, begin_separator ; next }
    /^-{3,}END [A-Z ]+-{3,}$/ { printf "%s%s", end_separator, $0 ; next }
    /^[A-Za-z0-9+/=]+$/ { printf "%s%s", $0, data_separator ; next }
    {
        print "Unknown line format: " $0 > "/dev/stderr"
        exit 1
    }
' "$input_file"

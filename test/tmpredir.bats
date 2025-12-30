#!/usr/bin/env bats

setup() {
    # Determine the directory of the script relative to this test file
    DIR="$( cd "$( dirname "$BATS_TEST_FILENAME" )" >/dev/null 2>&1 && pwd )"
    TMPREDIR="$DIR/../scripts/system/tmpredir"
    
    # Create dummy input files
    INPUT1=$(mktemp)
    echo "content1" > "$INPUT1"
    INPUT2=$(mktemp)
    echo "content2" > "$INPUT2"
}

teardown() {
    rm -f "$INPUT1" "$INPUT2"
}

@test "Show help message" {
    run bash "$TMPREDIR" --help
    [ "$status" -eq 0 ]
    [[ "${lines[0]}" =~ "Usage:" ]]
}

@test "Basic usage: append temp files as arguments" {
    run bash "$TMPREDIR" "$INPUT1" "$INPUT2" -- cat
    [ "$status" -eq 0 ]
    [[ "$output" == *"content1"* ]]
    [[ "$output" == *"content2"* ]]
}

@test "Placeholders: reorder inputs" {
    # %2 corresponds to INPUT2, %1 to INPUT1
    run bash "$TMPREDIR" "$INPUT1" "$INPUT2" -- cat %2 %1
    [ "$status" -eq 0 ]
    [ "${lines[0]}" = "content2" ]
    [ "${lines[1]}" = "content1" ]
}

@test "Stdin usage" {
    run bash -c "echo 'stdin_data' | bash '$TMPREDIR' -- cat"
    [ "$status" -eq 0 ]
    [ "$output" = "stdin_data" ]
}

@test "Escaping percent sign" {
    # %% should be converted to a single %
    # tmpredir implicitly appends temp files as arguments
    run bash "$TMPREDIR" "$INPUT1" -- echo "100%%"
    [ "$status" -eq 0 ]
    [[ "$output" =~ ^100%\ .*/tmpredir\..*$ ]]
}

@test "Error: No arguments" {
    run bash "$TMPREDIR"
    [ "$status" -eq 1 ]
}

@test "Error: No main command" {
    run bash "$TMPREDIR" "$INPUT1" --
    [ "$status" -eq 1 ]
    expected_error_message="^Error: No main command specified after --"
    [[ "$output" =~ $expected_error_message ]]
}

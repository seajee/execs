#!/usr/bin/env bash

execs() {
    # Extract user command and arguments
    local user_cmd="$@"
    local user_program="$1"

    # Check for the correct program usage
    if [[ -z "$user_program" ]]; then
        echo "Usage: execs [OPTION...] COMMAND"
        echo ""
        echo "  -e, --env   Prints execs environment variables"
        echo ""
        return 1
    fi

    # Handle options
    if [[ "$user_program" == "-e" ]] || [[ "$user_program" == "--env" ]]; then
        echo "EXECS_HOOKS:"
        for cmd in "${EXECS_HOOKS[@]}"; do
            echo "  $cmd"
        done

        return 0
    fi

    # Check if user command string starts with a dangerous command
    for cmd in "${EXECS_HOOKS[@]}"; do
        local program=$(echo "$cmd" | awk '{print $1;}')

        # If so, warn the user
        if [[ "$user_program" == "$program" ]] && [[ "$user_cmd" == "$cmd"* ]]; then
            echo -e "execs: Warning, the following command is flagged as dangerous by \"$cmd\"\n"
            read -p "Execute anyways? [Y/n] " answer

            if [[ "$answer" == [Nn]* ]]; then
                echo "execs: Aborting."
                return 1
            else
                break
            fi
        fi
    done

    # Otherwise execute the user command
    $user_cmd
}

execs_setup() {
    # Setup aliases for dangerous commands programs
    for cmd in "${EXECS_HOOKS[@]}"; do
        local program=$(echo "$cmd" | awk '{print $1;}')
        alias "$program"="execs $program"
    done
}

# Check if this script is being executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    echo "Please note that this script is intended to be sourced and should not be executed directly."
    exit 1
else
    execs_setup
fi

_ddev_custom_commands() {
    local project_dir="$HOME/Sites/ee248"
    local commands_dir="$project_dir/.ddev/commands/host"
    
    if [ -d "$commands_dir" ]; then
        local commands=$(ls -1 "$commands_dir" 2>/dev/null | grep -v "^README" | sort | tr '\n' ' ')
        COMPREPLY=($(compgen -W "$commands" -- "$cur"))
    fi
}

_ddev_completion() {
    local cur prev words cword
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    words=("${COMP_WORDS[@]}")
    cword=$COMP_CWORD

    if [[ $cword -eq 1 ]]; then
        _ddev_custom_commands
    fi
}

complete -F _ddev_completion ddev

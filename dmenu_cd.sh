#!/bin/bash
#
##DIR=$(ls /srv/http/projects/ | dmenu -i -fn "xft:Inconsolata:size=10" -p "Choose working dir")
##
##urxvt -cd "${DIR}"

#!/bin/bash
# Call dmenu on the given array of choices, effectively acting as a simple file explorer.
# If the selected choice is a folder, recursively open dmenu with the folder's contents as choices.
# If the selection is not a folder - or the current folder, denoted as '.' - attempt to open it with
# xdg-open or a tool configured via .edmrc-file and write the selection to a history file.
# The script can also open a terminal at the selected path.
#
# author: andreasl

define_standard_settings() {
    selected_path="/"
    history_file="${HOME}/.config/.edm_history"
    max_history_entries=3

    choices=(
        '$terminal'
        '$openWith'
        "$(cat "$history_file")"
        '.'
        '..'
        "$(ls "$selected_path")"
    )

        open_command='xdg-open'
        open_terminal_command='urxvt -cd'
}
define_standard_settings
source "${HOME}/.config/.edmrc" 2>/dev/null

write_selection_to_history_file() {
    sed -i "\:${selected_path}:d" "$history_file"
    printf '%s\n' "$selected_path" >> "$history_file"
    printf '%s\n' "$(tail -n "$max_history_entries" "$history_file")" > "$history_file"
}


while : ; do
    dmenu_result="$(printf '%s\n' "${choices[@]}" | dmenu -fn "xft:Inconsolata:size=10" -i -p "$selected_path" -l 50)" || exit 1
    if [ "$dmenu_result" = '$terminal' ]; then
        $open_terminal_command "$selected_path"
        write_selection_to_history_file
        exit 0
    fi

    if [ "$dmenu_result" = '$openWith' ]; then
        dmenu_result="$(ls /bin | dmenu -fn "xft:Inconsolata:size=10" -i -p "$selected_path" -l 50)" || exit 1
        $dmenu_result $selected_path
        write_selection_to_history_file
        exit 0
    fi

    if [[ "$dmenu_result" == "/"* ]]; then
        selected_path="${dmenu_result}"
    else
        selected_path="$(realpath "${selected_path}/${dmenu_result}")"
    fi
    if [ -f "$selected_path" ] || [ "$dmenu_result" = '.' ]; then
        $open_command "$selected_path"
        write_selection_to_history_file
        exit 0
    elif [ -d "$selected_path" ]; then
        echo ""
        choices=( '$terminal' '$openWith' '.' '..' "$(ls "$selected_path")")
    else
        selected_path="$(dirname "$selected_path")"
    fi
done


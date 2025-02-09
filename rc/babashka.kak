declare-option -docstring %{Path to 'bb' command} str babashka_path 'bb'

declare-user-mode babashka
map -docstring 'Babashka' global user b ': enter-user-mode babashka<ret>'
map -docstring 'Evaluate selection' global babashka e ': babashka-evaluate<ret>'
map -docstring 'Replace selection with evaluated result' global babashka R ': babashka-replace<ret>'

define-command \
    -params 0 \
    -docstring %{Replace selection with babashka result} \
    babashka-replace %{
    execute-keys '| "$kak_opt_babashka_path" --prn /dev/stdin<ret>'
}

define-command \
    -override \
    -params 0 \
    -docstring %{Evaluate selection with babashka} \
    babashka-evaluate %{
    evaluate-commands -no-hooks -draft -save-regs 'r^' %{
        try %{ execute-keys -itersel '<a-k>\A.\z<ret>m' }
        evaluate-commands -no-hooks %sh{
            eval set -- "$kak_quoted_selections"
            printf 'set-register a'
            for sel in "$@"; do
                printf " '"
                "$kak_opt_babashka_path" -e '
                    (print (str/replace (try
                                          (str "=> " (pr-str '"$sel"'))
                                          (catch Throwable t
                                            (str (.getSimpleName (class t)) ": " (.getMessage t))))
                                        "'"'"'"
                                        "'"''"'"))
                '
                printf "'"
            done
            printf '\n'
        }
        execute-keys '<a-:>a<space><esc>;'
        try %{ execute-keys -itersel '<a-l><a-k>\A\h*;[^\n]*\z<ret>' }
        execute-keys 'c<space>;<c-r>a<esc>'
    }
}

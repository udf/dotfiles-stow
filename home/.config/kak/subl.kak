## Sublime-like stuff
# select-all (Sublime's alt+f3) -> alt+3/alt+#
map global normal <a-3> ': select-all *<ret>'
map global normal <a-#> ': select-all <lt>a-*<gt><ret>'
# Searches for the current main selection in the buffer, then applies the
# new selections to the current main selection so that it's unchanged:
# <space>Z  - clear all except main selection and store it
# *  - store selected text in search register
#      this is <a-*> in the second mapping above, which behaves more like
#      sublime text since it selects irregardless of word boundaries
# %s<ret> - search the buffer for the text in the search register
# "sZ - save current selections to s register
# z - restore original selection, so that it stats as the main selection
# "s alt+z a - append the selections we saved from the search
define-command -override -params 1 -docstring %{
    Selects everything in the buffer that matches the current
    main selection
} select-all %{
    execute-keys %sh{ echo "<space>Z$1%s<ret>\"sZz\"s<a-z>a" }
    echo %sh{
        num_spaces=${kak_reg_s//[^ ]}
        num_spaces=${#num_spaces}
        echo -n "Found $num_spaces match"
        [ $num_spaces != 1 ] && echo es
    }
}

# select-next/previous (Sublime's ctrl+d) -> alt+v/V
map global normal <a-v> ': select-next<ret>'
map global normal <a-V> ': select-previous<ret>'
define-command -override -docstring %{
    Selects the next match of the current main selection
} select-next %{
    execute-keys *N
}
define-command -override -docstring %{
    Selects the previous match of the current main selection
} select-previous %{
    execute-keys *<a-N>
}

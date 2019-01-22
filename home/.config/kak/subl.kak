## Sublime-like stuff
# select-all (Sublime's alt+f3) -> alt+3/alt+#
map global normal <a-3> ': select-all<ret>'
map global normal <a-#> ': select-all-unbound<ret>'

# Searches for the current main selection in the buffer, then applies the
# searched selections after the current main selection so that it's unchanged:
# <space>Z  - clear all except main selection and store it
# *  - store selected text in search register
#      this is <a-*> in the second command below, which behaves more like
#      sublime text since it selects irregardless of word boundaries
# %s<ret> - search the buffer for the text in the search register
# "sZ - save current selections to s register
# z - restore original selection, so that it stats as the main selection
# "s alt+z a - append the selections we saved from the search
define-command -hidden -params 1 select-all-stub %{
    execute-keys %sh{ echo "<space>Z$1%s<ret>\"sZz\"s<a-z>a" }
    echo %sh{
        num_spaces=${kak_reg_s//[^ ]}
        num_spaces=${#num_spaces}
        echo -n "Found $num_spaces match"
        [ $num_spaces != 1 ] && echo es
    }
}

define-command -docstring %{
    Selects every word bound item in the buffer that matches the
    current main selection
} select-all %{
    select-all-stub *
}

define-command -docstring %{
    Selects every item in the buffer that matches the
    current main selection
} select-all-unbound %{
    select-all-stub <a-*>
}

## Sublime-like stuff
# select-all (Sublime's alt+f3) -> alt+3/alt+#
map global normal <a-3> ': select-all<ret>'
# Searches for the current main selection in the buffer, then applies the
# new selections to the current main selection so that it's unchanged:
# <space>Z  - clear all except main selection and store it
# *  - store selected text in search register
# %s<ret> - search the buffer for the text in the search register
# "sZ - save current selections to s register
# z - restore original selection, so that it stats as the main selection
# "s alt+z a - append the selections we saved from the search
define-command -override select-all %{
    execute-keys '<space>Z*%s<ret>"sZz"s<a-z>a'
    echo %sh{
        num_spaces=${kak_reg_s//[^ ]}
        num_spaces=${#num_spaces}
        echo -n "Found $num_spaces match"
        [ $num_spaces != 1 ] && echo es
    }
}

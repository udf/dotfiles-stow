evaluate-commands %sh{
    # black
    colour_0='rgb:2d2f33'
    colour_8='rgb:626873'
    # red
    colour_1='rgb:a54242'
    colour_9='rgb:cc6666'
    # green
    colour_2='rgb:6c9440'
    colour_10='rgb:92bd68' #unused
    # yellow
    colour_3='rgb:decc5f'
    colour_11='rgb:f0e396'
    # blue
    colour_4='rgb:5f819d'
    colour_12='rgb:81a2be'
    # magenta
    colour_5='rgb:ba70aa'
    colour_13='rgb:ba8baf'
    # cyan
    colour_6='rgb:5e8d87'
    colour_14='rgb:8abeb7' #unused
    # white
    colour_7='rgb:d4d7d9'
    colour_15='rgb:faffff'
    # base16 extra
    colour_16='rgb:ae81ff' #unused
    colour_17='rgb:ff8d5c'
    # base16 extra greys
    colour_18='rgb:242d35'
    colour_19='rgb:35434d'
    colour_20='rgb:9faab3'
    colour_21='rgb:dae0e6'

## code
    echo "
        face global value ${colour_17}
        face global type ${colour_3}
        face global variable ${colour_1}
        face global module ${colour_4}
        face global function ${colour_12}
        face global string ${colour_2}
        face global keyword ${colour_5}
        face global operator default
        face global attribute ${colour_13}
        face global comment ${colour_8}
        face global meta ${colour_9}
        face global builtin default
    "

    ## markup
    echo "
        face global title ${colour_4}
        face global header ${colour_12}
        face global bold ${colour_3}
        face global italic ${colour_5}
        face global mono ${colour_2}
        face global block ${colour_6}
        face global link ${colour_17}
        face global bullet ${colour_1}
        face global list default
    "

    ## builtin
    echo "
        face global Default ${colour_7}
        face global PrimarySelection ${colour_7},${colour_19}+fg
        face global SecondarySelection ${colour_20},${colour_0}+fg
        face global PrimaryCursor ${colour_0},${colour_15}+fg
        face global SecondaryCursor ${colour_0},${colour_20}+fg
        face global PrimaryCursorEol ${colour_0},${colour_20}+fg
        face global SecondaryCursorEol ${colour_0},${colour_8}+fg
        face global MenuForeground ${colour_19},${colour_15}
        face global MenuBackground ${colour_21},${colour_19}
        face global MenuInfo default
        face global Information ${colour_20},${colour_18}
        face global Error ${colour_18},${colour_1}
        face global StatusLine ${colour_20},${colour_18}
        face global StatusLineMode ${colour_3}
        face global StatusLineInfo default
        face global StatusLineValue ${colour_4}
        face global StatusCursor ${colour_18},${colour_20}
        face global Prompt ${colour_18},${colour_20}
        face global BufferPadding ${colour_8}
        face global LineNumbers ${colour_8},${colour_18}
        face global LineNumberCursor ${colour_21},${colour_18}
        face global LineNumbersWrapped ${colour_18},${colour_18}
        face global MatchingChar ${colour_0},${colour_20}+fg
        face global Whitespace ${colour_8}+f
    "

    ## extras
    echo "
        face global GitDiffFlags default,${colour_18}
        face global GitBlame ${colour_8},${colour_18}
        face global LineFlagErrors ${colour_1},${colour_18}
        face global CursorLine default,${colour_18}
        face global SearchMatches ${colour_18},${colour_11}+f
    "
}

module Style.Colors exposing (colors)

import Css exposing (Color, hex)


type alias Colors =
    { nearWhite : Color
    , lightGray : Color
    , darkGray : Color
    , white : Color
    }


colors : Colors
colors =
    { nearWhite = hex "f4f4f4"
    , lightGray = hex "dddddd"
    , darkGray = hex "333333"
    , white = hex "ffffff"
    }

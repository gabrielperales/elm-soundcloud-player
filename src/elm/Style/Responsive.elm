module Style.Responsive exposing (tablet, desktop)

import Css exposing (px, em)
import Css.Media as Media exposing (media, only, screen)


tablet css =
    media [ only screen [ Media.minWidth <| px 480 ] ] css


desktop css =
    media [ only screen [ Media.minWidth <| em 64 ] ] css

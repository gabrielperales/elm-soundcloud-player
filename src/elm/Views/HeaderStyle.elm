module Views.HeaderStyle exposing (css, Class(..))

import Css exposing (..)
import Css.Namespace exposing (namespace)
import Style.Colors exposing (colors)


type Class
    = HeaderContainer
    | Logo
    | SearchField
    | SearchFieldInput


css : Stylesheet
css =
    (stylesheet << namespace "header")
        [ class HeaderContainer
            [ position fixed
            , top zero
            , width <| pct 100
            , height <| em 3
            , backgroundColor colors.darkGray
            , color colors.white
            ]
        , class Logo []
        , class SearchField
            [ display block
            ]
        , class SearchFieldInput
            [ display block
            , border zero
            , height <| pct 100
            ]
        ]

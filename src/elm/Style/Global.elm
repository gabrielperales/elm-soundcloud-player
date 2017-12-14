module Style.Global exposing (css, globalClass, Class(..), maxWidth)

import Style.Colors exposing (colors)
import Html exposing (Attribute)
import Html.CssHelpers as CssHelpers
import Css exposing (..)
import Css.Elements exposing (body)
import Css.Namespace exposing (namespace)


type Class
    = Maxwidth
    | Center
    | Flex
    | JustifySpaceBetween
    | DirectionRow
    | DirectionColumn
    | AlignItemsCenter
    | H100
    | W100


css : Stylesheet
css =
    (stylesheet << namespace "global")
        [ body
            [ margin zero
            , padding zero
            , fontFamilies [ "Roboto", "sans-serif" ]
            , backgroundColor colors.nearWhite
            ]
        , class Maxwidth
            [ maxWidth
            , width <| pct 100
            , marginLeft auto
            , marginRight auto
            ]
        , class Center
            [ marginLeft auto
            , marginRight auto
            ]
        , class Flex
            [ displayFlex ]
        , class JustifySpaceBetween
            [ justifyContent spaceBetween ]
        , class DirectionRow
            [ flexDirection row ]
        , class DirectionColumn
            [ flexDirection column ]
        , class AlignItemsCenter
            [ alignItems center ]
        , class H100
            [ height <| pct 100 ]
        , class W100
            [ width <| pct 100 ]
        ]


maxWidth =
    Css.maxWidth <| em 64


globalClass : List Class -> Attribute msg
globalClass =
    CssHelpers.withNamespace "global" |> .class

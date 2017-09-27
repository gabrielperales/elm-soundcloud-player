module Views.SongListStyle exposing (css, Class(..))

import Css exposing (..)
import Css.Namespace exposing (namespace)
import Style.Colors exposing (colors)


type Class
    = List
    | Item


css : Stylesheet
css =
    (stylesheet << namespace "songlist")
        [ class List
            [ listStyle none
            , margin zero
            , padding zero
            , paddingTop <| em 3
            , paddingBottom <| px 100
            , backgroundColor colors.nearWhite
            ]
        , class Item
            [ marginTop zero
            , marginBottom zero
            , padding zero
            , listStyle none
            ]
        ]

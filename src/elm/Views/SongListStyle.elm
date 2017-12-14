module Views.SongListStyle exposing (css, Class(..))

import Css exposing (..)
import Css.Namespace exposing (namespace)
import Style.Responsive exposing (tablet)
import Style.Global as Global


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
            ]
        , class Item
            [ marginTop zero
            , marginBottom zero
            , padding zero
            , listStyle none
            ]
        , tablet
            [ class List
                [ displayFlex
                , flexWrap wrap
                , flexDirection row
                , marginLeft auto
                , marginRight auto
                , Global.maxWidth
                ]
            , class Item
                [ width <| pct 25
                ]
            ]
        ]

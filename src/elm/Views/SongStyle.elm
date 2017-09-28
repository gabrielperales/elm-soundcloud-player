module Views.SongStyle exposing (css, Class(..))

import Css exposing (..)
import Css.Elements exposing (img)
import Css.Namespace exposing (namespace)
import Style.Responsive exposing (tablet)
import Style.Colors exposing (colors)


type Class
    = Container
    | Image
    | Title
    | Description


css : Stylesheet
css =
    (stylesheet << namespace "song")
        [ class Container
            [ borderBottom3 (px 1) solid colors.lightGray
            , backgroundColor colors.nearWhite
            , boxSizing borderBox
            ]
        , class Image
            [ marginRight <| em 0.5
            , height <| px 50
            , width <| px 50
            , children
                [ img [ width inherit, height inherit ] ]
            ]
        , class Title
            [ margin <| em 0.25
            , fontSize <| em 0.8
            ]
        , tablet
            [ class Container
                [ backgroundColor colors.white
                , border3 (px 1) solid colors.lightGray
                , maxWidth <| px 180
                , flexDirection column
                , padding <| em 0.5
                , margin <| em 0.5
                , marginLeft auto
                , marginRight auto
                ]
            , class Image
                [ width <| pct 100
                , height <| px 80
                , overflow hidden
                , boxSizing borderBox
                , children
                    [ img
                        [ height <| px 180
                        , position relative
                        , top <| px -50
                        ]
                    ]
                ]
            ]
        ]

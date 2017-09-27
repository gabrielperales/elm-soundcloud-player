module Views.SongStyle exposing (css, Class(..))

import Css exposing (..)
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
            ]
        , class Image
            [ marginRight <| em 0.5
            , height <| px 100
            , width <| px 100
            ]
        , tablet []
        ]

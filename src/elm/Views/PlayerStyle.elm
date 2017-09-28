module Views.PlayerStyle exposing (css, Class(..))

import Css exposing (..)
import Css.Namespace exposing (namespace)


type Class
    = Container


css : Stylesheet
css =
    (stylesheet << namespace "player")
        [ class Container
            [ position fixed
            , bottom zero
            , width <| pct 100
            , backgroundColor <| rgba 0 0 0 0.95
            , height <| px 100
            ]
        ]

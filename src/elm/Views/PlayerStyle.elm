module Views.PlayerStyle exposing (css)

import Css exposing (..)
import Css.Namespace exposing (namespace)


type Class
    = Nop


css : Stylesheet
css =
    (stylesheet << namespace "song")
        []

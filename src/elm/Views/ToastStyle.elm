module Views.ToastStyle exposing (css)

import Css exposing (..)
import Css.Namespace exposing (namespace)
import Style.Colors exposing (colors)


css : Stylesheet
css =
    (stylesheet << namespace "toasty-")
        [ class "container"
            [ padding <| em 1
            , borderRadius <| px 5
            , cursor pointer
            , boxShadow5 zero (px 5) (px 5) (px -5) (rgba 0 0 0 0.5)
            , color <| colors.white
            ]
        , class "title"
            [ fontSize <| em 1
            , margin zero
            ]
        , class "message"
            [ fontSize <| em 0.9
            , marginTop <| em 0.5
            , marginBottom zero
            ]
        , class "success"
            [ backgroundColor colors.success
            ]
        , class "warning"
            [ backgroundColor colors.warning
            ]
        , class "error"
            [ backgroundColor colors.error
            ]
        ]

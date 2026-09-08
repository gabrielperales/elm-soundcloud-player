module Views.Spinner exposing (view)

import Html exposing (Html, node, div)
import Html.Attributes exposing (class, style)


view : Html msg
view =
    div
        [ style "position" "fixed"
        , style "left" "0"
        , style "right" "0"
        , style "top" "0"
        , style "bottom" "0"
        , style "z-index" "999999"
        , style "text-align" "center"
        , style "background-color" "rgba(0, 0, 0, 0.2)"
        , style "display" "flex"
        , style "align-items" "center"
        , style "justify-content" "center"
        ]
        [ node "i"
            [ class "fa fa-spinner fa-pulse fa-3x fa-fw"
            ]
            []
        ]

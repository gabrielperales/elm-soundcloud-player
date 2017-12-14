module Views.Spinner exposing (view)

import Html exposing (Html, node, div)
import Html.Attributes exposing (class, style)


view : Html msg
view =
    div
        [ style
            [ ( "position", "fixed" )
            , ( "left", "0" )
            , ( "right", "0" )
            , ( "top", "0" )
            , ( "bottom", "0" )
            , ( "z-index", "999999" )
            , ( "text-align", "center" )
            , ( "background-color", "rgba(0, 0, 0, 0.2)" )
            , ( "display", "flex" )
            , ( "align-items", "center" )
            , ( "justify-content", "center" )
            ]
        ]
        [ node "i"
            [ class "fa fa-spinner fa-pulse fa-3x fa-fw"
            ]
            []
        ]

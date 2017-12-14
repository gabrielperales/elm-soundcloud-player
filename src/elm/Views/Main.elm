module Views.Main exposing (view)

import Html exposing (Html, div)
import Html.Attributes exposing (class)


view : List (Html msg) -> Html msg
view children =
    div [ class "bg-near-white h-100 pt4 pb5 scroll" ] children

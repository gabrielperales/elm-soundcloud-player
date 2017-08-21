module Views.Player exposing (view)

import Data.Song as Song exposing (Song)
import Html exposing (Html, div, text)


view : Maybe Song -> msg -> msg -> msg -> Html msg
view maybeSong play pause stop =
    case maybeSong of
        Just song ->
            div [] []

        Nothing ->
            text ""

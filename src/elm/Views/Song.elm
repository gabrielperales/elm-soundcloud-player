module Views.Song exposing (view)

import Data.Song as Song exposing (Song)
import Html exposing (Html, a, text)
import Html.Attributes exposing (href)
import Html.Events exposing (onClick)


view : Song -> msg -> Html msg
view song onclick =
    a [ href "#", onClick onclick ] [ text song.title ]

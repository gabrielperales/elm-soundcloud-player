module Views.SongList exposing (view)

import Data.Song exposing (Song)
import Html exposing (Html, li, ul)
import Views.Song as SongView


view : List Song -> msg -> Html msg
view songs onclick =
    songs
        |> List.map (\song -> li [] [ SongView.view song onclick ])
        |> ul []

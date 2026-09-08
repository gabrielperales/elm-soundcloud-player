module Views.SongList exposing (view)

import Data.Song exposing (Song)
import Html exposing (Html, li, ul)
import Html.Attributes exposing (class)
import Views.Song as SongView


view : List Song -> (Song -> msg) -> Html msg
view songs onclick =
    songs
        |> List.map
            (\song ->
                li [ class "songlist-item" ]
                    [ SongView.view song (onclick song) ]
            )
        |> ul [ class "songlist-list" ]

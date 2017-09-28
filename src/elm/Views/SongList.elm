module Views.SongList exposing (view)

import Data.Song exposing (Song)
import Html exposing (Html, li, ul)
import Html.CssHelpers as CssHelpers
import Views.Song as SongView
import Views.SongListStyle as Style


{ class } =
    CssHelpers.withNamespace "songlist"


view : List Song -> (Song -> msg) -> Html msg
view songs onclick =
    songs
        |> List.map
            (\song ->
                li [ class [ Style.Item ] ]
                    [ SongView.view song (onclick song) ]
            )
        |> ul [ class [ Style.List ] ]

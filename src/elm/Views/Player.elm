module Views.Player exposing (view)

import Data.Song as Song exposing (Song)
import Html exposing (Html, div, img, text, button, p)
import Html.Attributes exposing (class, src)
import Html.Events exposing (onClick)
import Html.CssHelpers as CssHelpers
import Maybe
import Views.PlayerStyle as Style


{ class } =
    CssHelpers.withNamespace "player"


view : Maybe Song -> Bool -> (Song -> msg) -> msg -> msg -> msg -> Html msg
view maybeSong isPlaying play pause prev next =
    case maybeSong of
        Just song ->
            let
                { title, artwork_url } =
                    song

                playPauseBtn =
                    if isPlaying then
                        button [ onClick pause ] [ text "pause" ]
                    else
                        button [ onClick <| play song ] [ text "play" ]
            in
                div [ class [ Style.Container ] ]
                    [ div []
                        [ div []
                            [ img [ src <| Maybe.withDefault "" artwork_url ] []
                            ]
                        , div [] [ p [] [ text title ] ]
                        , div []
                            [ button [ onClick prev ] [ text "prev" ]
                            , playPauseBtn
                            , button [ onClick next ] [ text "next" ]
                            ]
                        ]
                    ]

        Nothing ->
            text ""

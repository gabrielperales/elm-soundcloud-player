module Views.Player exposing (view)

import Data.Song as Song exposing (Song)
import Html exposing (Html, div, img, text, button, p, i)
import Html.Attributes as Attr exposing (class, src, style)
import Html.Events exposing (onClick)
import Html.CssHelpers as CssHelpers
import Maybe
import Views.PlayerStyle as Style
import Style.Global as Global exposing (globalClass)


{ class } =
    CssHelpers.withNamespace "player"


view : Maybe Song -> Bool -> (Song -> msg) -> msg -> msg -> msg -> Html msg
view maybeSong isPlaying play pause prev next =
    case maybeSong of
        Just song ->
            let
                { title, artwork_url, user } =
                    song

                { username } =
                    user

                playPauseBtn =
                    if isPlaying then
                        i [ Attr.class "fa fa-pause", onClick pause ] []
                    else
                        i [ Attr.class "fa fa-play", onClick <| play song ] []
            in
                div [ class [ Style.Container ] ]
                    [ div [ globalClass [ Global.Maxwidth, Global.AlignItemsCenter ] ]
                        [ div [ class [ Style.Player ] ]
                            [ div [ class [ Style.SongArtwork ], style [ ( "background-image", "url(" ++ Maybe.withDefault "assets/elm_logo.png" artwork_url ++ ")" ) ] ] []
                            , div [ class [ Style.PlayerButtons ] ]
                                [ i [ Attr.class "fa fa-caret-left", onClick prev ] []
                                , playPauseBtn
                                , i [ Attr.class "fa fa-caret-right", onClick next ] []
                                ]
                            , div []
                                [ div [ class [ Style.SongTitle ] ] [ text title ]
                                , div [ class [ Style.Author ] ] [ text username ]
                                ]
                            ]
                        ]
                    ]

        Nothing ->
            text ""

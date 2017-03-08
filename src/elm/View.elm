module View exposing (..)

import Model exposing (..)
import Messages exposing (..)
import Html exposing (..)
import Html.Events exposing (onClick, onSubmit)
import Html.Attributes exposing (..)
import Date
import Date.Format exposing (format)
import Time exposing (..)
import Material as Mdl
import Material.Icon as Icon
import Material.Textfield as Textfield
import Material.Card as Card
import Material.List as List
import Material.Button as Button
import Material.Slider as Slider
import Material.Grid as Grid exposing (..)
import Material.Options as Options exposing (css)
import Material.Layout as Layout


-- VIEW


view : Model -> Html Msg
view model =
    let
        currentSongHtml =
            renderPlayingSong model.is_playing model.elapsed_time model.current_song

        searchSongsHtml =
            renderSongs renderSong model.songs

        playlistHtml =
            if (not <| List.isEmpty model.playlist) then
                div []
                    [ h3 [] [ text "Playlist" ]
                    , button [ onClick PlayNext ] [ text "Next" ]
                    , renderSongs renderPlayListSong model.playlist
                    ]
            else
                text ""
    in
        Layout.render Mdl
            model.mdl
            [ Layout.fixedHeader ]
            { header =
                [ grid []
                    [ cell [ Grid.size All 12 ]
                        [ Html.form [ onSubmit (Search model.query) ]
                            [ Textfield.render Mdl
                                [ 2 ]
                                model.mdl
                                [ Textfield.label "some song...", Textfield.value model.query, Options.onInput Change ]
                                []
                            , Button.render Mdl
                                [ 0 ]
                                model.mdl
                                [ Button.icon
                                , Button.ripple
                                ]
                                [ Icon.i "search" ]
                            , audio [] []
                            ]
                        ]
                    ]
                ]
            , drawer = []
            , tabs = ( [], [] )
            , main =
                [ grid []
                    [ cell [ Grid.size All 6, Grid.size Phone 12 ] [ currentSongHtml ]
                    , cell [ Grid.size All 6, Grid.size Phone 12 ]
                        [ playlistHtml
                        , searchSongsHtml
                        ]
                    ]
                ]
            }


renderPlayingSong : Bool -> Time -> Maybe Song -> Html Msg
renderPlayingSong is_playing elapsed_time playing =
    let
        displayFormat time =
            time
                |> Date.fromTime
                |> format "%M:%S"

        btn icon msg =
            Button.render Mdl
                [ 0 ]
                model.mdl
                [ Button.icon
                , Button.ripple
                , Button.colored
                , Options.onClick msg
                ]
                [ Icon.i icon ]

        cover url =
            case url of
                Just img_src ->
                    img [ src img_src ] []

                _ ->
                    text ""
    in
        case playing of
            Just song ->
                let
                    artwork_url =
                        Maybe.withDefault "" song.artwork_url
                in
                    Card.view [ css "width" "100%" ]
                        [ Card.title [] [ Card.head [] [ text song.title ] ]
                        , Card.media
                            [ css "background" ("url(" ++ artwork_url ++ ") center/150px no-repeat")
                            , css "height" "200px"
                            ]
                            []
                        , Card.text [ css "text-align" "center" ] [ text (displayFormat elapsed_time ++ "/" ++ displayFormat song.duration) ]
                        , Card.actions []
                            [ grid []
                                [ cell [ Grid.size All 12 ]
                                    [ if is_playing then
                                        btn "pause" Pause
                                      else
                                        btn "play_arrow" (Play song)
                                    , btn "stop" Stop
                                    , btn "skip_next" PlayNext
                                    ]
                                ]
                            , br [] []
                            , Slider.view [ Slider.onChange Seek, Slider.value elapsed_time, Slider.max song.duration ]
                            ]
                        ]

            Nothing ->
                text ""


renderSong : Song -> List (Html Msg)
renderSong song =
    [ List.content []
        [ List.avatarImage (Maybe.withDefault "" song.artwork_url) []
        , a [ href "#", onClick <| Play song ] [ text song.title ]
        ]
    , List.content2 []
        [ Button.render Mdl
            [ 0 ]
            model.mdl
            [ Button.icon
            , Button.ripple
            , Options.onClick (AddToPlaylist song)
            ]
            [ Icon.i "playlist_add" ]
        ]
    ]


renderPlayListSong : Song -> List (Html Msg)
renderPlayListSong song =
    [ text song.title ]


renderSongs : (Song -> List (Html Msg)) -> List Song -> Html Msg
renderSongs renderfn songs =
    songs
        |> List.map (renderfn >> List.li [])
        |> (List.ul [])

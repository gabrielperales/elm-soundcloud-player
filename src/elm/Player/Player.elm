module Player.Player
    exposing
        ( Model
        , Msg
        , configurePlayer
        , play
        , setClientId
        , subscriptions
        , update
        , view
        )

import Data.Song as Song exposing (Song)
import Html exposing (Html, div, img, text, button, p, i)
import Html.Attributes as Attr exposing (class, src, style)
import Html.CssHelpers as CssHelpers
import Html.Events exposing (onClick)
import Maybe
import Ports exposing (playSong, pauseSong, stopSong, seekSong, endSong)
import Style.Global as Global exposing (globalClass)
import Time exposing (Time, every, second)
import Player.Style as Style


{ class } =
    CssHelpers.withNamespace "player"


type Msg
    = Play Song
    | PlayNext
    | PlayPrev
    | LoadPlaylist (List Song)
    | Pause
    | Stop
    | Seek Time
    | Tick


type ClientId
    = ClientId String


type alias Model =
    { is_playing : Bool
    , elapsed_time : Time
    , playlist : List Song
    , client_id : ClientId
    , song : Maybe Song
    }


setClientId : String -> ClientId
setClientId clientId =
    ClientId clientId


getClientId : ClientId -> String
getClientId (ClientId clientid) =
    clientid


configurePlayer : ClientId -> Model
configurePlayer client_id =
    { is_playing = False
    , elapsed_time = 0
    , playlist = []
    , client_id = client_id
    , song = Nothing
    }


play : Song -> Msg
play =
    Play


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Play song ->
            { model | song = Just song, is_playing = True } ! [ playSong (Maybe.withDefault "" song.stream_url ++ "?client_id=" ++ getClientId model.client_id) ]

        Pause ->
            { model | is_playing = False } ! [ pauseSong () ]

        LoadPlaylist playlist ->
            { model | playlist = playlist } ! []

        Tick ->
            let
                elapsed_time : Time
                elapsed_time =
                    ((+) second) model.elapsed_time
            in
                { model | elapsed_time = elapsed_time } ! []

        _ ->
            model ! []


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ if (model.is_playing) then
            every second <| always Tick
          else
            Sub.none
        , endSong (always PlayNext)
        ]


view : Model -> Html Msg
view { song, is_playing, elapsed_time } =
    case song of
        Just song ->
            let
                { title, artwork_url, user } =
                    song

                { username } =
                    user

                playPauseBtn =
                    if is_playing then
                        i [ Attr.class "fa fa-pause", onClick Pause ] []
                    else
                        i [ Attr.class "fa fa-play", onClick <| Play song ] []
            in
                div [ class [ Style.Container ] ]
                    [ div [ globalClass [ Global.Maxwidth, Global.AlignItemsCenter ] ]
                        [ div [ class [ Style.Player ] ]
                            [ div [ class [ Style.SongArtwork ], style [ ( "background-image", "url(" ++ Maybe.withDefault "assets/elm_logo.png" artwork_url ++ ")" ) ] ] []
                            , div [ class [ Style.PlayerButtons ] ]
                                [ i [ Attr.class "fa fa-caret-left", onClick PlayPrev ] []
                                , playPauseBtn
                                , i [ Attr.class "fa fa-caret-right", onClick PlayNext ] []
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

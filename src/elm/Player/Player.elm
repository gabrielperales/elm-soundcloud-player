module Player.Player exposing
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
import Html exposing (Html, div, img, text, button, p, i, input)
import Html.Attributes as Attr exposing (class, src, style)
import Html.Events exposing (onClick, on)
import Maybe
import Player.Event exposing (onChange)
import Ports exposing (playSong, pauseSong, stopSong, seekSong, endSong)
import Time


type Msg
    = Play Song
    | PlayNext
    | PlayPrev
    | LoadPlaylist (List Song)
    | Pause
    | Stop
    | Seek Float
    | Tick


type ClientId
    = ClientId String


type alias Model =
    { is_playing : Bool
    , elapsed_time : Float
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


padTime : Int -> String
padTime n =
    String.padLeft 2 '0' (String.fromInt n)


formatTime : Float -> String
formatTime time =
    let
        totalSeconds =
            truncate (time / 1000)

        minutes =
            totalSeconds // 60

        seconds =
            modBy 60 totalSeconds
    in
    padTime minutes ++ ":" ++ padTime seconds


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Play song ->
            let
                elapsed_time =
                    if Just song == model.song then
                        model.elapsed_time

                    else
                        0
            in
            ( { model | song = Just song, is_playing = True, elapsed_time = elapsed_time }
            , playSong (Maybe.withDefault "" song.stream_url ++ "?client_id=" ++ getClientId model.client_id)
            )

        Pause ->
            ( { model | is_playing = False }, pauseSong () )

        Stop ->
            ( { model | song = Nothing, is_playing = False, elapsed_time = 0 }, stopSong () )

        LoadPlaylist playlist ->
            ( { model | playlist = playlist }, Cmd.none )

        Seek time ->
            ( { model | elapsed_time = time }, seekSong time )

        Tick ->
            ( { model | elapsed_time = model.elapsed_time + 1000 }, Cmd.none )

        _ ->
            ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ if model.is_playing then
            Time.every 1000 (always Tick)

          else
            Sub.none
        , endSong (always Stop)
        ]


view : Model -> Html Msg
view { song, is_playing, elapsed_time } =
    case song of
        Just currentSong ->
            let
                { title, artwork_url, user } =
                    currentSong

                { username } =
                    user

                playPauseBtn =
                    if is_playing then
                        i [ Attr.class "fa fa-pause", onClick Pause ] []

                    else
                        i [ Attr.class "fa fa-play", onClick <| Play currentSong ] []
            in
            div [ class "player-container" ]
                [ div [ class "global-maxwidth global-align-items-center" ]
                    [ div [ class "player-player" ]
                        [ div [ class "player-song-artwork", style "background-image" ("url(" ++ Maybe.withDefault "assets/elm_logo.png" artwork_url ++ ")") ] []
                        , div []
                            [ div [ class "player-song-title" ] [ text title ]
                            , div [ class "player-author" ] [ text username ]
                            ]
                        , div [ class "player-player-buttons" ]
                            [ i [ Attr.class "fa fa-caret-left", onClick PlayPrev ] []
                            , playPauseBtn
                            , i [ Attr.class "fa fa-caret-right", onClick PlayNext ] []
                            ]
                        , div [ class "player-time" ] [ text <| formatTime elapsed_time ++ " / " ++ formatTime currentSong.duration ]
                        , input
                            [ class "player-slider"
                            , Attr.type_ "range"
                            , Attr.value <| String.fromFloat elapsed_time
                            , Attr.max <| String.fromFloat currentSong.duration
                            , onChange Seek
                            ]
                            []
                        ]
                    ]
                ]

        Nothing ->
            text ""

module App exposing (..)

import Types exposing (..)
import Ports exposing (..)
import Views exposing (..)
import FetchSongs exposing (..)
import Html exposing (..)
import Html.Events exposing (..)
import Time exposing (..)
import Material as Mdl


main : Program Flags Model Msg
main =
    Html.programWithFlags
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- MODEL


initialModel : Model
initialModel =
    { query = ""
    , songs = []
    , current_song = Nothing
    , is_playing = False
    , elapsed_time = 0
    , playlist = []
    , client_id = ""
    , mdl = Mdl.model
    }


init : Flags -> ( Model, Cmd Msg )
init flags =
    let
        { client_id } =
            flags
    in
        ( { initialModel | client_id = client_id }
        , Cmd.none
        )



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Search query ->
            ( model, getSongs query model.client_id )

        Change input ->
            ( { model | query = input }, Cmd.none )

        Play song ->
            let
                time =
                    if (Just song /= model.current_song) then
                        0
                    else
                        model.elapsed_time
            in
                ( { model | current_song = Just song, is_playing = True, elapsed_time = time }
                , playSong (song.stream_url ++ "?client_id=" ++ model.client_id)
                )

        PlayNext ->
            case model.playlist of
                song :: list ->
                    update (Play song) { model | playlist = list }

                _ ->
                    update Stop model

        Pause ->
            ( { model | is_playing = False }, pauseSong "" )

        Stop ->
            ( { model | current_song = Nothing, is_playing = False, elapsed_time = 0 }, stopSong "" )

        Seek time ->
            ( { model | elapsed_time = time }, seekSong time )

        SongList (Ok songs) ->
            ( { model | songs = songs }, Cmd.none )

        SongList (Err _) ->
            ( model, Cmd.none )

        AddToPlaylist song ->
            ( { model | playlist = List.append model.playlist [ song ] }, Cmd.none )

        Tick ->
            let
                new_time : Time
                new_time =
                    ((+) second) model.elapsed_time
            in
                ( { model | elapsed_time = new_time }, Cmd.none )

        -- Boilerplate: Mdl action handler.
        Mdl msg_ ->
            Mdl.update Mdl msg_ model



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ if (model.is_playing) then
            every second <| always Tick
          else
            Sub.none
        , endSong (always PlayNext)
        ]

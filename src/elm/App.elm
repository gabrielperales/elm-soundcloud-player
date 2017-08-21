module App exposing (main)

import Data.Song exposing (Song)
import Data.Flags exposing (Flags)
import Ports exposing (playSong, pauseSong, stopSong, seekSong, endSong)
import Request.Song
import Time exposing (Time, every, second)
import Http
import Html exposing (Html, div)


main : Program Flags Model Msg
main =
    Html.programWithFlags
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- MODEL


type alias Model =
    { query : String
    , songs : List Song
    , current_song : Maybe Song
    , is_playing : Bool
    , elapsed_time : Time
    , playlist : List Song
    , client_id : String
    }


initialModel : Model
initialModel =
    { query = ""
    , songs = []
    , current_song = Nothing
    , is_playing = False
    , elapsed_time = 0
    , playlist = []
    , client_id = ""
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



-- VIEW


view : Model -> Html Msg
view model =
    div [] []



-- UPDATE


type Msg
    = Search String
    | Change String
    | Play Song
    | Stop
    | Pause
    | Seek Time
    | PlayNext
    | SongList (Result Http.Error (List Song))
    | Tick
    | AddToPlaylist Song


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Search query ->
            let
                cmd =
                    Request.Song.list query model.client_id
                        |> Http.send SongList
            in
                ( model, cmd )

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

module App exposing (main)

import Data.Song exposing (Song)
import Data.Flags exposing (Flags)
import Ports exposing (playSong, pauseSong, stopSong, seekSong, endSong)
import Request.Song as RequestSong
import Time exposing (Time, every, second)
import Http
import Html exposing (Html, div, text, input)
import Views.Header as HeaderView
import Views.SongList as SongList
import Views.Player as Player
import Views.Main as Main
import Http exposing (Error(..))
import Toasty


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
    , toasties : Toasty.Stack String
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
    , toasties = Toasty.initialState
    }


init : Flags -> ( Model, Cmd Msg )
init { client_id } =
    update Search { initialModel | client_id = client_id }



-- VIEW


view : Model -> Html Msg
view { songs, current_song, is_playing, toasties } =
    div []
        [ HeaderView.view Change Search
        , Main.view [ SongList.view songs Play ]
        , Player.view current_song is_playing Play Pause NoOp NoOp
        , Toasty.view Toasty.config (\toast -> div [] [ text toast ]) ToastyMsg toasties
        ]



-- UPDATE


type Msg
    = Search
    | Change String
    | Play Song
    | Stop
    | Pause
    | Seek Time
    | PlayNext
    | SongList (Result Http.Error (List Song))
    | Tick
    | AddToPlaylist Song
    | ToastyMsg (Toasty.Msg String)
    | NoOp


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Search ->
            let
                cmd =
                    RequestSong.list model.client_id model.query
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
            { model | is_playing = False } ! [ pauseSong "" ]

        Stop ->
            { model | current_song = Nothing, is_playing = False, elapsed_time = 0 } ! [ stopSong "" ]

        Seek time ->
            { model | elapsed_time = time } ! [ seekSong time ]

        SongList (Ok songs) ->
            { model | songs = songs } ! []

        SongList (Err error) ->
            case error of
                BadPayload debug _ ->
                    ( model, Cmd.none )
                        |> Toasty.addToast Toasty.config ToastyMsg debug

                _ ->
                    model ! []

        AddToPlaylist song ->
            { model | playlist = List.append model.playlist [ song ] } ! []

        Tick ->
            let
                new_time : Time
                new_time =
                    ((+) second) model.elapsed_time
            in
                { model | elapsed_time = new_time } ! []

        ToastyMsg toastyMsg ->
            Toasty.update Toasty.config ToastyMsg toastyMsg model

        NoOp ->
            model ! []



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

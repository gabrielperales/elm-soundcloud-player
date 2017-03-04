module Main exposing (..)

import Ports exposing (..)
import Model exposing (..)
import Messages exposing (..)
import View exposing (..)
import Html exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode as Decode exposing (Decoder, decodeString, field, map, oneOf, string, int, float, at, null)
import Time exposing (..)
import Material as Mdl


client_id : String
client_id =
    "eb6df903547f8123e3cb79e5429a0999"


onChange : (Time -> msg) -> Attribute msg
onChange toMsg =
    at [ "target", "value" ] string
        |> Decode.map (String.toInt >> Result.withDefault 0 >> toFloat >> toMsg)
        |> on "change"


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


init : ( Model, Cmd Msg )
init =
    ( model
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Search query ->
            ( model, getSongs query )

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
                , playSong (song.stream_url ++ "?client_id=" ++ client_id)
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


getSongs : String -> Cmd Msg
getSongs query =
    let
        limit =
            toString 50

        url =
            "http://api.soundcloud.com/tracks?client_id=" ++ client_id ++ "&limit=" ++ limit ++ "&q=" ++ query
    in
        Http.send SongList (Http.get url decodeSongs)


decodeSongs : Decoder (List Song)
decodeSongs =
    Decode.list
        (Decode.map5 Song
            (field "id" int)
            (field "title" string)
            (field "artwork_url" (oneOf [ Decode.map Just string, null Nothing ]))
            (field "duration" float)
            (field "stream_url" string)
        )

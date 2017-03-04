port module Main exposing (..)

import Material as Mdl
import Material.Icon as Icon
import Material.Textfield as Textfield
import Material.Card as Card
import Material.List as List


--import Material.Color as Color

import Material.Button as Button
import Material.Slider as Slider
import Material.Grid as Grid exposing (..)
import Material.Options as Options exposing (css)
import Material.Layout as Layout
import Html exposing (..)
import Html.Attributes as Attr exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode as Decode exposing (Decoder, decodeString, field, map, oneOf, string, int, float, at, null)
import Time exposing (..)
import Date
import Date.Format exposing (format)


client_id : String
client_id =
    "eb6df903547f8123e3cb79e5429a0999"


port playSong : String -> Cmd msg


port pauseSong : String -> Cmd msg


port stopSong : String -> Cmd msg


port seekSong : Time -> Cmd msg


port endSong : (() -> msg) -> Sub msg


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



-- MODEL


type alias Model =
    { query : String
    , songs : List Song
    , current_song : Maybe Song
    , is_playing : Bool
    , elapsed_time : Time
    , playlist : List Song
    , mdl :
        Mdl.Model
        -- Boilerplate: model store for any and all Mdl components you use.
    }


type alias Song =
    { id : Int
    , title : String
    , artwork_url : Maybe String
    , duration : Time
    , stream_url : String
    }


model : Model
model =
    Model "" [] Nothing False 0 [] Mdl.model


init : ( Model, Cmd Msg )
init =
    ( model
    , Cmd.none
    )



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
    | Mdl (Mdl.Msg Msg)


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
                        [ searchSongsHtml
                        , playlistHtml
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



-- HTTP


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

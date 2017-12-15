module App exposing (main)

import Data.Song exposing (Song)
import Data.Collection exposing (Collection)
import Data.Flag exposing (Flag)
import Data.Genre exposing (Genre(..))
import Ports exposing (playSong, pauseSong, stopSong, seekSong, endSong)
import Request.Song as RequestSong
import Time exposing (Time, every, second)
import Http
import Html exposing (Html, div, text, input)
import Html.Attributes exposing (style)
import Views.Header as HeaderView
import Views.SongList as SongList
import Views.Player as Player
import Views.Main as Main
import Views.Toast as Toast exposing (Toast)
import Views.Spinner as Spinner
import Http exposing (Error(..))
import InfiniteScroll as IS
import Task


main : Program Flag Model Msg
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
    , genre : Genre
    , songs : List Song
    , current_song : Maybe Song
    , is_playing : Bool
    , elapsed_time : Time
    , playlist : List Song
    , client_id : String
    , toasties : Toast.Stack Toast
    , page : Int
    , infiniteScroll : IS.Model Msg
    , next_href : Maybe String
    }


loadMore : IS.Direction -> Cmd Msg
loadMore dir =
    Task.perform OnLoadMore <| Task.succeed dir


initialModel : Model
initialModel =
    { query = ""
    , genre = House
    , songs = []
    , current_song = Nothing
    , is_playing = False
    , elapsed_time = 0
    , playlist = []
    , client_id = ""
    , toasties = Toast.initialState
    , page = 0
    , infiniteScroll = IS.init loadMore
    , next_href = Nothing
    }


init : Flag -> ( Model, Cmd Msg )
init { client_id } =
    update Search { initialModel | client_id = client_id }



-- VIEW


view : Model -> Html Msg
view { songs, current_song, is_playing, toasties, infiniteScroll } =
    div [ IS.infiniteScroll InfiniteScrollMsg, style [ ( "height", "100vh" ), ( "overflow", "scroll" ) ] ]
        [ HeaderView.view UpdateSearchInput ChangeGenre Search
        , Main.view [ SongList.view songs Play ]
        , Player.view current_song is_playing Play Pause NoOp NoOp
        , Toast.view ToastMsg toasties
        , if IS.isLoading infiniteScroll then
            div [] [ Spinner.view ]
          else
            text ""
        ]



-- UPDATE


type Msg
    = Search
    | InfiniteScrollMsg IS.Msg
    | OnLoadMore IS.Direction
    | UpdateSearchInput String
    | ChangeGenre Genre
    | Play Song
    | Stop
    | Pause
    | Seek Time
    | PlayNext
    | SongList (Result Http.Error Collection)
    | Tick
    | AddToPlaylist Song
    | ToastMsg (Toast.Msg Toast)
    | NoOp


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ChangeGenre genre ->
            { model | genre = genre }
                |> update Search

        Search ->
            let
                cmd =
                    RequestSong.defaultOptions model.client_id
                        |> RequestSong.query model.query
                        |> RequestSong.linked_partitioning 0
                        |> RequestSong.limit 50
                        |> RequestSong.tags [ toString model.genre ]
                        |> RequestSong.request
                        |> Http.send SongList
            in
                { model | songs = [] } ! [ cmd ]

        InfiniteScrollMsg msg_ ->
            let
                ( infiniteScroll, cmd ) =
                    IS.update InfiniteScrollMsg msg_ model.infiniteScroll
            in
                { model | infiniteScroll = infiniteScroll } ! [ cmd ]

        OnLoadMore direction ->
            let
                cmd =
                    case model.next_href of
                        Just url ->
                            Http.get url Data.Collection.decoder
                                |> Http.send SongList

                        Nothing ->
                            Cmd.none
            in
                model ! [ cmd ]

        UpdateSearchInput input ->
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
                , playSong (Maybe.withDefault "" song.stream_url ++ "?client_id=" ++ model.client_id)
                )
                    |> Toast.addToast ToastMsg (Toast.success "Playing song..." song.title)

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

        SongList (Ok { collection, next_href }) ->
            let
                page =
                    case next_href of
                        Just _ ->
                            model.page + 1

                        Nothing ->
                            model.page

                songsWithStreaming =
                    List.filterMap .stream_url collection

                infiniteScroll =
                    IS.stopLoading model.infiniteScroll
            in
                { model
                    | songs = model.songs ++ collection
                    , page = page
                    , next_href = next_href
                    , infiniteScroll = infiniteScroll
                }
                    ! []

        SongList (Err error) ->
            let
                infiniteScroll =
                    IS.stopLoading model.infiniteScroll
            in
                case error of
                    BadPayload debug _ ->
                        Toast.addToast ToastMsg
                            (Toast.error "There was an error retrieving songs..." debug)
                            ( model, Cmd.none )

                    _ ->
                        { model | infiniteScroll = infiniteScroll } ! []

        AddToPlaylist song ->
            { model | playlist = List.append model.playlist [ song ] } ! []

        Tick ->
            let
                new_time : Time
                new_time =
                    ((+) second) model.elapsed_time
            in
                { model | elapsed_time = new_time } ! []

        ToastMsg toastmsg ->
            Toast.update ToastMsg toastmsg model

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

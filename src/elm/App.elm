module App exposing (main)

import Data.Song exposing (Song)
import Data.Collection exposing (Collection)
import Data.Flag exposing (Flag)
import Data.Genre exposing (Genre(..))
import Request.Song as RequestSong
import Http
import Navigation exposing (Location)
import Html exposing (Html, div, text, input)
import Html.Attributes exposing (style)
import Views.Header as HeaderView
import Views.SongList as SongList
import Views.Main as Main
import Views.Toast as Toast exposing (Toast)
import Views.Spinner as Spinner
import Http exposing (Error(..))
import InfiniteScroll as IS
import Task
import Route exposing (Route)
import Player.Player as Player


main : Program Flag Model Msg
main =
    Navigation.programWithFlags (SetRoute << Route.fromLocation)
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- MODEL


type alias Model =
    { query : String
    , genre : Maybe Genre
    , songs : List Song
    , current_song : Maybe Song
    , playlist : List Song
    , client_id : String
    , toasties : Toast.Stack Toast
    , page : Int
    , infiniteScroll : IS.Model Msg
    , next_href : Maybe String
    , player : Player.Model
    }


loadMore : IS.Direction -> Cmd Msg
loadMore dir =
    Task.perform OnLoadMore <| Task.succeed dir


configurePlayer : String -> Model
configurePlayer client_id =
    { query = ""
    , genre = Nothing
    , songs = []
    , current_song = Nothing
    , playlist = []
    , client_id = client_id
    , toasties = Toast.initialState
    , page = 0
    , infiniteScroll = IS.init loadMore
    , next_href = Nothing
    , player = Player.configurePlayer <| Player.setClientId client_id
    }


init : Flag -> Location -> ( Model, Cmd Msg )
init { client_id } location =
    update (SetRoute (Route.fromLocation location)) <| configurePlayer client_id



-- VIEW


view : Model -> Html Msg
view { player, genre, songs, current_song, toasties, infiniteScroll } =
    div [ IS.infiniteScroll InfiniteScrollMsg, style [ ( "height", "100vh" ), ( "overflow", "scroll" ) ] ]
        [ HeaderView.view genre UpdateSearchInput Search
        , Main.view [ SongList.view songs (PlayerMsg << Player.play) ]
        , Html.map PlayerMsg (Player.view player)
        , Toast.view ToastMsg toasties
        , if IS.isLoading infiniteScroll then
            div [] [ Spinner.view ]
          else
            text ""
        ]



-- UPDATE


type Msg
    = AddToPlaylist Song
    | InfiniteScrollMsg IS.Msg
    | NoOp
    | OnLoadMore IS.Direction
    | PlayerMsg Player.Msg
    | Search
    | SetRoute (Maybe Route)
    | SongList (Result Http.Error Collection)
    | ToastMsg (Toast.Msg Toast)
    | UpdateSearchInput String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        AddToPlaylist song ->
            { model | playlist = List.append model.playlist [ song ] } ! []

        InfiniteScrollMsg msg_ ->
            let
                ( infiniteScroll, cmd ) =
                    IS.update InfiniteScrollMsg msg_ model.infiniteScroll
            in
                { model | infiniteScroll = infiniteScroll } ! [ cmd ]

        NoOp ->
            model ! []

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

        PlayerMsg msg ->
            let
                ( player, cmd ) =
                    Player.update msg model.player
            in
                { model | player = player } ! [ Cmd.map PlayerMsg cmd ]

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

        SetRoute maybeRoute ->
            case maybeRoute of
                Just (Route.Genre genre) ->
                    { model | genre = Just genre }
                        |> update Search

                _ ->
                    model ! []

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

        ToastMsg toastmsg ->
            Toast.update ToastMsg toastmsg model

        UpdateSearchInput input ->
            ( { model | query = input }, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Sub.map PlayerMsg (Player.subscriptions model.player)
        ]

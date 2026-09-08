module App exposing (main)

import Browser
import Browser.Navigation as Nav
import Data.Song exposing (Song)
import Data.Collection exposing (Collection)
import Data.Flag exposing (Flag)
import Data.Genre exposing (Genre(..))
import Request.Song as RequestSong
import Http
import Url exposing (Url)
import Html exposing (Html, div, text, input)
import Html.Attributes exposing (style)
import Views.Header as HeaderView
import Views.SongList as SongList
import Views.Main as Main
import Views.Toast as Toast exposing (Toast)
import Views.Spinner as Spinner
import InfiniteScroll as IS
import Task
import Route exposing (Route)
import Player.Player as Player


main : Program Flag Model Msg
main =
    Browser.application
        { init = init
        , view = \model -> { title = "SoundCloud Elm App", body = [ view model ] }
        , update = update
        , subscriptions = subscriptions
        , onUrlChange = SetRoute << Route.fromUrl
        , onUrlRequest = OnUrlRequest
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
    , isMenuOpen : Bool
    , key : Nav.Key
    }


loadMore : IS.Direction -> Cmd Msg
loadMore dir =
    Task.perform OnLoadMore <| Task.succeed dir


configurePlayer : String -> Nav.Key -> Model
configurePlayer client_id key =
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
    , isMenuOpen = False
    , key = key
    }


init : Flag -> Url -> Nav.Key -> ( Model, Cmd Msg )
init { client_id } url key =
    update (SetRoute (Route.fromUrl url)) <| configurePlayer client_id key



-- VIEW


view : Model -> Html Msg
view { player, genre, songs, current_song, toasties, isMenuOpen, infiniteScroll } =
    div [ IS.infiniteScroll InfiniteScrollMsg, style "height" "100vh", style "overflow" "scroll" ]
        [ HeaderView.view genre isMenuOpen UpdateSearchInput ToggleMenu Search
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
    | OnUrlRequest Browser.UrlRequest
    | PlayerMsg Player.Msg
    | Search
    | SetRoute (Maybe Route)
    | SongList (Result Http.Error Collection)
    | ToastMsg (Toast.Msg Toast)
    | ToggleMenu
    | UpdateSearchInput String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        AddToPlaylist song ->
            ( { model | playlist = List.append model.playlist [ song ] }, Cmd.none )

        InfiniteScrollMsg msg_ ->
            let
                ( infiniteScroll, cmd ) =
                    IS.update InfiniteScrollMsg msg_ model.infiniteScroll
            in
            ( { model | infiniteScroll = infiniteScroll }, cmd )

        NoOp ->
            ( model, Cmd.none )

        OnLoadMore direction ->
            let
                cmd =
                    case model.next_href of
                        Just url ->
                            Http.get
                                { url = url
                                , expect = Http.expectJson SongList Data.Collection.decoder
                                }

                        Nothing ->
                            Cmd.none
            in
            ( model, cmd )

        OnUrlRequest _ ->
            ( model, Cmd.none )

        PlayerMsg playerMsg ->
            let
                ( player, cmd ) =
                    Player.update playerMsg model.player
            in
            ( { model | player = player }, Cmd.map PlayerMsg cmd )

        Search ->
            let
                genreTags =
                    model.genre
                        |> Maybe.map Data.Genre.genreToString
                        |> Maybe.map List.singleton
                        |> Maybe.withDefault []

                cmd =
                    RequestSong.defaultOptions model.client_id
                        |> RequestSong.query model.query
                        |> RequestSong.linked_partitioning 0
                        |> RequestSong.limit 50
                        |> RequestSong.tags genreTags
                        |> (\options -> RequestSong.request options SongList)
            in
            ( { model | songs = [] }, cmd )

        SetRoute maybeRoute ->
            case maybeRoute of
                Just (Route.Genre genre) ->
                    { model | genre = Just genre }
                        |> update Search

                _ ->
                    ( model, Cmd.none )

        SongList (Ok { collection, next_href }) ->
            let
                page =
                    case next_href of
                        Just _ ->
                            model.page + 1

                        Nothing ->
                            model.page

                infiniteScroll =
                    IS.stopLoading model.infiniteScroll
            in
            ( { model
                | songs = model.songs ++ collection
                , page = page
                , next_href = next_href
                , infiniteScroll = infiniteScroll
              }
            , Cmd.none
            )

        SongList (Err error) ->
            let
                infiniteScroll =
                    IS.stopLoading model.infiniteScroll
            in
            case error of
                Http.BadBody debug ->
                    Toast.addToast ToastMsg
                        (Toast.error "There was an error retrieving songs..." debug)
                        ( model, Cmd.none )

                _ ->
                    ( { model | infiniteScroll = infiniteScroll }, Cmd.none )

        ToastMsg toastmsg ->
            Toast.update ToastMsg toastmsg model

        ToggleMenu ->
            ( { model | isMenuOpen = not model.isMenuOpen }, Cmd.none )

        UpdateSearchInput input ->
            ( { model | query = input }, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Sub.map PlayerMsg (Player.subscriptions model.player)
        ]

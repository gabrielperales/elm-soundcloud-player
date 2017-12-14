module Views.Toast
    exposing
        ( initialState
        , view
        , update
        , addToast
        , Stack
        , Toast
        , Msg
        , success
        , warning
        , error
        )

import Html exposing (Html, div, text)
import Html.Attributes exposing (style)
import Toasty exposing (Msg(..))
import Toasty.Defaults as Defaults exposing (Toast(..))


config : Toasty.Config msg
config =
    Defaults.config
        |> Toasty.containerAttrs
            [ style
                [ ( "position", "fixed" )
                , ( "z-index", "99999" )
                , ( "top", "0" )
                , ( "right", "0" )
                , ( "width", "100%" )
                , ( "max-width", "300px" )
                , ( "list-style-type", "none" )
                , ( "padding", "0" )
                , ( "margin", "0" )
                ]
            ]


initialState : Toasty.Stack Toast
initialState =
    Toasty.initialState


type alias Stack a =
    Toasty.Stack a


type alias Toast =
    Defaults.Toast


type alias Msg a =
    Toasty.Msg a


view : (Msg Toast -> msg) -> Stack Toast -> Html msg
view tagger stack =
    Toasty.view config Defaults.view tagger stack


update : (Msg a -> msg) -> Msg a -> { m | toasties : Stack a } -> ( { m | toasties : Stack a }, Cmd msg )
update =
    Toasty.update config


addToast : (Msg a -> msg) -> a -> ( { m | toasties : Stack a }, Cmd msg ) -> ( { m | toasties : Stack a }, Cmd msg )
addToast =
    Toasty.addToast config


error : String -> String -> Toast
error =
    Error


warning : String -> String -> Toast
warning =
    Warning


success : String -> String -> Toast
success =
    Success

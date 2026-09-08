module Views.Toast exposing
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
import Toasty
import Toasty.Defaults as Defaults exposing (Toast(..))


config : Toasty.Config msg
config =
    Defaults.config
        |> Toasty.containerAttrs
            [ style "position" "fixed"
            , style "z-index" "99999"
            , style "top" "0"
            , style "right" "0"
            , style "width" "100%"
            , style "max-width" "300px"
            , style "list-style-type" "none"
            , style "padding" "0"
            , style "margin" "0"
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

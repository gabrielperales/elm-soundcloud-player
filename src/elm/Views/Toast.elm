module Views.Toast exposing (view)

import Html exposing (Html, div, text)
import Toasty
import Toasty.Defaults as Defaults


config : Toasty.Config Toast
config =
    Defaults.config


initialState : Toasty.Stack Toast
initialState =
    Toasty.initialState


type alias Msg =
    Toasty.Msg


type alias Toast =
    Defaults.Toast


view : Toast -> Html msg
view toast =
    Defaults.view toast


update : Msg -> Toasty.Stack Toast
update msg =
    initialState

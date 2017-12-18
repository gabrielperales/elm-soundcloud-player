module Player.Event exposing (onChange)

import Html exposing (Attribute)
import Html.Events exposing (on)
import Json.Decode as Decode exposing (at, string)
import Time exposing (Time)


onChange : (Time -> msg) -> Attribute msg
onChange toMsg =
    at [ "target", "value" ] string
        |> Decode.map (String.toInt >> Result.withDefault 0 >> toFloat >> toMsg)
        |> on "change"

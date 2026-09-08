module Player.Event exposing (onChange)

import Html exposing (Attribute)
import Html.Events exposing (on)
import Json.Decode as Decode exposing (at, string)


onChange : (Float -> msg) -> Attribute msg
onChange toMsg =
    at [ "target", "value" ] string
        |> Decode.map (String.toInt >> Maybe.withDefault 0 >> toFloat >> toMsg)
        |> on "change"

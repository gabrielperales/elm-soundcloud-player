module Util exposing (renderMaybe)

import Html exposing (Html, text)


renderMaybe : Maybe a -> (a -> Html msg) -> Html msg
renderMaybe maybe renderFn =
    case maybe of
        Just value ->
            renderFn value

        Nothing ->
            text ""


renderIf : Bool -> Html msg -> Html msg
renderIf cond html =
    if cond then
        html
    else
        text ""

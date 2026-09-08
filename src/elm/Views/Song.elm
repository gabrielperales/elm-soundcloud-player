module Views.Song exposing (view)

import Data.Song as Song exposing (Song)
import Html exposing (Html, div, a, img, h4, p, text, i)
import Html.Attributes as Attr exposing (class, src, href, style)
import Html.Events exposing (onClick)
import Regex exposing (Regex)
import Maybe


largeArtworkRegex : Regex
largeArtworkRegex =
    Maybe.withDefault Regex.never (Regex.fromString "-large\\.jpg$")


replaceSize : Maybe String -> Maybe String
replaceSize =
    Maybe.map <| Regex.replace largeArtworkRegex (\_ -> "-t300x300.jpg")


view : Song -> msg -> Html msg
view { title, user, artwork_url, description } onclick =
    let
        artwork =
            Maybe.withDefault "assets/elm_logo.png" (replaceSize artwork_url)
    in
    div [ class "song-container global-flex global-direction-row", onClick onclick ]
        [ div
            [ class "song-image"
            , style "background" ("url(" ++ artwork ++ ") no-repeat 50%")
            , style "background-size" "cover"
            ]
            [ div [ class "song-play-button", style "transition" "opacity 0.2s" ] [ i [ Attr.class "fa fa-2x fa-play" ] [] ] ]
        , div [ class "song-main" ]
            [ div [ class "song-avatar", style "background-image" ("url(" ++ user.avatar_url ++ ")") ] []
            , div []
                [ h4 [ class "song-title" ] [ text title ]
                , div [ class "song-username" ] [ text user.username ]
                ]
            ]
        ]

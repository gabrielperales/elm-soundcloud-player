module Route exposing (Route(..), fromUrl, href)

import Html exposing (Attribute)
import Html.Attributes as Attr
import Url exposing (Url)
import Url.Parser as UrlParser exposing ((</>), Parser, oneOf, s)
import Data.Genre as Genre exposing (Genre(..))


type Route
    = Home
    | Genre Genre


route : Parser (Route -> a) a
route =
    oneOf
        [ UrlParser.map Home UrlParser.top
        , UrlParser.map Genre (s "genre" </> Genre.genreParser)
        ]


routeToString : Route -> String
routeToString page =
    let
        pieces =
            case page of
                Home ->
                    []

                Genre genre ->
                    [ "genre", Genre.genreToString genre ]
    in
    "#/" ++ String.join "/" pieces


href : Route -> Attribute msg
href =
    Attr.href << routeToString


fromUrl : Url -> Maybe Route
fromUrl url =
    let
        fragment =
            Maybe.withDefault "" url.fragment
    in
    if String.isEmpty fragment then
        Just <| Genre House

    else
        { url
            | path = fragment
            , fragment = Nothing
        }
            |> UrlParser.parse route

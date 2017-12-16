module Route exposing (Route(..), fromLocation, href)

import Html exposing (Attribute)
import Html.Attributes as Attr
import Navigation exposing (Location)
import UrlParser as Url exposing ((</>), Parser, oneOf, parseHash, s, string)
import Data.Genre as Genre exposing (Genre)


type Route
    = Home
    | Genre Genre


route : Parser (Route -> a) a
route =
    oneOf
        [ Url.map Home (s "")
        , Url.map Genre (s "genre" </> Genre.genreParser)
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


modifyUrl : Route -> Cmd msg
modifyUrl =
    Navigation.modifyUrl << routeToString


fromLocation : Location -> Maybe Route
fromLocation location =
    if String.isEmpty location.hash then
        Just Home
    else
        parseHash route location

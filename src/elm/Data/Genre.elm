module Data.Genre exposing (Genre(..), genreToString, genreParser)

import UrlParser


type Genre
    = House
    | Chill
    | Deep
    | Dubstep
    | Progressive
    | Tech
    | Trance
    | Tropical


genreToString : Genre -> String
genreToString =
    String.toLower << toString


fromString : String -> Maybe Genre
fromString string =
    case String.toLower string of
        "house" ->
            Just House

        "chill" ->
            Just Chill

        "deep" ->
            Just Deep

        "dubstep" ->
            Just Dubstep

        "progressive" ->
            Just Progressive

        "tech" ->
            Just Tech

        "trance" ->
            Just Trance

        "tropical" ->
            Just Tropical

        _ ->
            Nothing


genreParser : UrlParser.Parser (Genre -> a) a
genreParser =
    UrlParser.custom "GENRE" (Result.fromMaybe "error parsing genre" << fromString)

module Data.Genre exposing (Genre(..), genreToString, genreParser)

import Url.Parser


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
genreToString genre =
    case genre of
        House ->
            "house"

        Chill ->
            "chill"

        Deep ->
            "deep"

        Dubstep ->
            "dubstep"

        Progressive ->
            "progressive"

        Tech ->
            "tech"

        Trance ->
            "trance"

        Tropical ->
            "tropical"


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


genreParser : Url.Parser.Parser (Genre -> a) a
genreParser =
    Url.Parser.custom "GENRE" fromString

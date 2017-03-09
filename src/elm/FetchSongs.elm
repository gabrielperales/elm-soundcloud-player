module FetchSongs exposing (..)

import Http
import Types exposing (..)
import Json.Decode as Decode exposing (Decoder, decodeString, field, map, oneOf, string, int, float, at, null)


getSongs : String -> String -> Cmd Msg
getSongs query client_id =
    let
        limit =
            toString 50

        url =
            "http://api.soundcloud.com/tracks?client_id=" ++ client_id ++ "&limit=" ++ limit ++ "&q=" ++ query
    in
        Http.send SongList (Http.get url decodeSongs)


decodeSongs : Decoder (List Song)
decodeSongs =
    Decode.list
        (Decode.map5 Song
            (field "id" int)
            (field "title" string)
            (field "artwork_url" (oneOf [ Decode.map Just string, null Nothing ]))
            (field "duration" float)
            (field "stream_url" string)
        )

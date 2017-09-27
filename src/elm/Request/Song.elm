module Request.Song exposing (..)

import Data.Song as Song exposing (Song)
import Json.Decode as Decode
import Http exposing (Request)


list : String -> String -> Request (List Song)
list client_id query =
    let
        limit =
            toString 50

        url =
            "http://api.soundcloud.com/tracks?client_id=" ++ client_id ++ "&limit=" ++ limit ++ "&q=" ++ query
    in
        Http.get url (Decode.list Song.decoder)

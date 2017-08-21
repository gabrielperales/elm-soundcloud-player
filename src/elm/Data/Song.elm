module Data.Song exposing (Song, decoder)

import Time exposing (Time)
import Json.Decode as Decode exposing (Decoder, field, int, string, float, oneOf, null)


type alias Song =
    { id : Int
    , title : String
    , artwork_url : Maybe String
    , duration : Time
    , stream_url : String
    }



-- SERIALIZATION


decoder : Decoder Song
decoder =
    (Decode.map5 Song
        (field "id" int)
        (field "title" string)
        (field "artwork_url" (oneOf [ Decode.map Just string, null Nothing ]))
        (field "duration" float)
        (field "stream_url" string)
    )

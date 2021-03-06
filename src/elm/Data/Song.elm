module Data.Song exposing (Song, decoder)

import Data.User as User exposing (User)
import Time exposing (Time)
import Json.Decode as Decode exposing (Decoder, field, int, string, float, oneOf, null)


type alias Song =
    { id : Int
    , user : User
    , title : String
    , artwork_url : Maybe String
    , duration : Time
    , stream_url : Maybe String
    , description : Maybe String
    , genre : Maybe String
    }



-- SERIALIZATION


decoder : Decoder Song
decoder =
    (Decode.map8 Song
        (field "id" int)
        (field "user" User.decoder)
        (field "title" string)
        (field "artwork_url" (oneOf [ Decode.map Just string, null Nothing ]))
        (field "duration" float)
        (field "stream_url" (oneOf [ Decode.map Just string, null Nothing ]))
        (field "description" (oneOf [ Decode.map Just string, null Nothing ]))
        (field "genre" (oneOf [ Decode.map Just string, null Nothing ]))
    )

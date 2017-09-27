module Data.User exposing (User, decoder)

import Json.Decode as Decode exposing (Decoder, field, string, int)


type alias User =
    { id : Int
    , username : String
    }



-- SERIALIZATION


decoder : Decoder User
decoder =
    (Decode.map2 User
        (field "id" int)
        (field "username" string)
    )

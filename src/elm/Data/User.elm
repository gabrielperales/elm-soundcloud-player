module Data.User exposing (User, decoder)

import Json.Decode as Decode exposing (Decoder, field, string, int)


type alias User =
    { id : Int
    , username : String
    , avatar_url : String
    }



-- SERIALIZATION


decoder : Decoder User
decoder =
    (Decode.map3 User
        (field "id" int)
        (field "username" string)
        (field "avatar_url" string)
    )

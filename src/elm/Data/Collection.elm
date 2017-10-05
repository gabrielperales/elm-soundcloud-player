module Data.Collection exposing (Collection, decoder)

import Data.Song as Song exposing (Song)
import Json.Decode as Decode exposing (Decoder, list, field, string, oneOf, null)


type alias Collection =
    { collection : List Song
    , next_href : Maybe String
    }


decoder : Decoder Collection
decoder =
    (Decode.map2 Collection
        (field "collection" <| list Song.decoder)
        (field "next_href" (oneOf [ Decode.map Just string, null Nothing ]))
    )

module Model exposing (..)

import Material as Mdl
import Time exposing (..)


-- MODEL


type alias Model =
    { query : String
    , songs : List Song
    , current_song : Maybe Song
    , is_playing : Bool
    , elapsed_time : Time
    , playlist : List Song
    , mdl :
        Mdl.Model
        -- Boilerplate: model store for any and all Mdl components you use.
    }


type alias Song =
    { id : Int
    , title : String
    , artwork_url : Maybe String
    , duration : Time
    , stream_url : String
    }


model : Model
model =
    Model "" [] Nothing False 0 [] Mdl.model

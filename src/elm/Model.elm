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
    , client_id : String
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
    { query = ""
    , songs = []
    , current_song = Nothing
    , is_playing = False
    , elapsed_time = 0
    , playlist = []
    , client_id = ""
    , mdl = Mdl.model
    }

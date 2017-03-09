module Types exposing (..)

import Time exposing (Time)
import Material as Mdl
import Http


type alias Flags =
    { client_id : String
    }


type alias Song =
    { id : Int
    , title : String
    , artwork_url : Maybe String
    , duration : Time
    , stream_url : String
    }


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


type Msg
    = Search String
    | Change String
    | Play Song
    | Stop
    | Pause
    | Seek Time
    | PlayNext
    | SongList (Result Http.Error (List Song))
    | Tick
    | AddToPlaylist Song
    | Mdl (Mdl.Msg Msg)

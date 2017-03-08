module Messages exposing (..)

import Time exposing (..)
import Material as Mdl
import Model exposing (..)
import Http


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

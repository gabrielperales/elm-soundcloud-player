port module Ports exposing (..)

import Time exposing (..)


port playSong : String -> Cmd msg


port pauseSong : String -> Cmd msg


port stopSong : String -> Cmd msg


port seekSong : Time -> Cmd msg


port endSong : (() -> msg) -> Sub msg

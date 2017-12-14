port module Ports exposing (playSong, pauseSong, stopSong, seekSong, endSong)

import Time exposing (Time)


port playSong : String -> Cmd msg


port pauseSong : String -> Cmd msg


port stopSong : String -> Cmd msg


port seekSong : Time -> Cmd msg


port endSong : (() -> msg) -> Sub msg

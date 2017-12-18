port module Ports exposing (playSong, pauseSong, stopSong, seekSong, endSong)

import Time exposing (Time)


port playSong : String -> Cmd msg


port pauseSong : () -> Cmd msg


port stopSong : () -> Cmd msg


port seekSong : Time -> Cmd msg


port endSong : (() -> msg) -> Sub msg

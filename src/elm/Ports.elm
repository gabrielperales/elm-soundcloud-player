port module Ports exposing (playSong, pauseSong, stopSong, seekSong, endSong)


port playSong : String -> Cmd msg


port pauseSong : () -> Cmd msg


port stopSong : () -> Cmd msg


port seekSong : Float -> Cmd msg


port endSong : (() -> msg) -> Sub msg

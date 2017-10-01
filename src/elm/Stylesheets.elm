port module Stylesheets exposing (main)

import Css.File exposing (..)
import Style.Global as Global
import Views.HeaderStyle as HeaderStyle
import Views.SongStyle as SongStyle
import Views.SongListStyle as SongListStyle
import Views.PlayerStyle as PlayerStyle
import Views.ToastStyle as ToastStyle


port files : CssFileStructure -> Cmd msg


cssFiles : CssFileStructure
cssFiles =
    toFileStructure
        [ ( "style.css"
          , Css.File.compile
                [ Global.css
                , HeaderStyle.css
                , SongStyle.css
                , SongListStyle.css
                , PlayerStyle.css
                , ToastStyle.css
                ]
          )
        ]


main : CssCompilerProgram
main =
    Css.File.compiler files cssFiles

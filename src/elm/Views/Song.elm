module Views.Song exposing (view)

import Data.Song as Song exposing (Song)
import Html exposing (Html, div, a, img, h4, p, text)
import Html.Attributes as Attr exposing (class, src, href)
import Html.Events exposing (onClick)
import Html.CssHelpers as CssHelpers
import Views.SongStyle as Style
import Style.Global as Global exposing (globalClass)
import Maybe


{ class } =
    CssHelpers.withNamespace "song"


view : Song -> msg -> Html msg
view { title, artwork_url, description } onclick =
    let
        artwork =
            Maybe.withDefault "" artwork_url
    in
        div [ class [ Style.Container ], globalClass [ Global.Flex, Global.DirectionRow ], onClick onclick ]
            [ div [ class [ Style.Image ] ]
                [ img [ src artwork ] []
                ]
            , div []
                [ h4 [] [ text title ]
                ]
            ]

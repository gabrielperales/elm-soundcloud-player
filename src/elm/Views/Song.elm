module Views.Song exposing (view)

import Data.Song as Song exposing (Song)
import Html exposing (Html, div, a, img, h4, p, text, i)
import Html.Attributes as Attr exposing (class, src, href, style)
import Html.Events exposing (onClick)
import Html.CssHelpers as CssHelpers
import Regex exposing (HowMany(..), replace, regex)
import Views.SongStyle as Style
import Style.Global as Global exposing (globalClass)
import Maybe


{ class } =
    CssHelpers.withNamespace "song"


replaceSize : Maybe String -> Maybe String
replaceSize =
    Maybe.map <| replace (AtMost 1) (regex "-large.jpg$") (\_ -> "-t300x300.jpg")


view : Song -> msg -> Html msg
view { title, user, artwork_url, description } onclick =
    let
        artwork =
            Maybe.withDefault "assets/elm_logo.png" (replaceSize artwork_url)
    in
        div [ class [ Style.Container ], globalClass [ Global.Flex, Global.DirectionRow ], onClick onclick ]
            [ div
                [ class [ Style.Image ]
                , style [ ( "background", "url(" ++ artwork ++ ") no-repeat 50%" ), ( "background-size", "cover" ) ]
                ]
                [ div [ class [ Style.PlayButton ], style [ ( "transition", "opacity 0.2s" ) ] ] [ i [ Attr.class "fa fa-2x fa-play" ] [] ] ]
            , div [ class [ Style.Main ] ]
                [ div [ class [ Style.Avatar ], style [ ( "background", "url(" ++ user.avatar_url ++ ") no-repeat " ) ] ] []
                , div []
                    [ h4 [ class [ Style.Title ] ] [ text title ]
                    , div [ class [ Style.Username ] ] [ text user.username ]
                    ]
                ]
            ]

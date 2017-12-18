module Player.Style exposing (css, Class(..))

import Css exposing (..)
import Css.Elements exposing (i)
import Css.Namespace exposing (namespace)


type Class
    = Container
    | Player
    | PlayerButtons
    | SongTitle
    | SongArtwork
    | Time
    | Author


css : Stylesheet
css =
    (stylesheet << namespace "player")
        [ class Container
            [ position fixed
            , bottom zero
            , width <| pct 100
            , backgroundColor <| rgba 0 0 0 0.95
            , height <| px 48
            ]
        , class Player
            [ displayFlex
            , alignItems center
            , height <| pct 100
            , color <| hex "aaa"
            ]
        , class PlayerButtons
            [ displayFlex
            , justifyContent spaceBetween
            , marginRight <| px 10
            , color <| hex "ddd"
            , width <| px 70
            , children
                [ i
                    [ margin <| px 2
                    , padding <| px 5
                    , cursor pointer
                    ]
                ]
            ]
        , class SongTitle
            [ fontSize <| em 0.7
            , width <| px 150
            , overflow hidden
            , textOverflow ellipsis
            , whiteSpace noWrap
            ]
        , class Time [ fontSize <| em 0.7 ]
        , class SongArtwork
            [ width <| px 48
            , height <| px 48
            , marginRight <| px 10
            , backgroundSize cover
            ]
        , class Author
            [ color <| hex "3381b7"
            , marginTop <| px 2
            , fontSize <| em 0.6
            ]
        ]

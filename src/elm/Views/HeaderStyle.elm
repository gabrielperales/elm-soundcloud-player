module Views.HeaderStyle exposing (css, Class(..))

import Css exposing (..)
import Css.Elements exposing (img)
import Css.Namespace exposing (namespace)
import Style.Colors exposing (colors)
import Style.Responsive exposing (desktop)


type Class
    = HeaderContainer
    | Logo
    | SearchField
    | SearchFieldInput
    | GenresNav
    | Genres
    | Genre
    | CurrentGenre


css : Stylesheet
css =
    (stylesheet << namespace "header")
        [ class HeaderContainer
            [ position fixed
            , top zero
            , left zero
            , right zero
            , height <| em 3
            , backgroundColor colors.darkGray
            , color colors.white
            , zIndex <| int 1
            , paddingLeft <| em 0.5
            , paddingRight <| em 0.5
            ]
        , class Logo
            [ displayFlex
            , alignItems center
            , textDecoration none
            , color colors.white
            , children
                [ img
                    [ height <| px 25
                    , width <| px 25
                    , marginRight <| em 0.5
                    ]
                ]
            ]
        , class SearchField
            [ display block
            ]
        , class SearchFieldInput
            [ display inlineBlock
            , border zero
            , marginLeft <| em 0.5
            , height <| pct 100
            , fontSize <| em 1
            ]
        , class GenresNav
            [ backgroundColor <| rgb 255 255 255
            , borderBottom3 (px 1) solid (hex "dddddd")
            ]
        , class Genre
            [ displayFlex
            , justifyContent center
            , color inherit
            , textDecoration none
            , alignItems center
            , cursor pointer
            , borderLeft2 (px 1) solid
            , borderColor <| hex "dddddd"
            , fontSize <| em 0.6
            , height <| px 30
            , width <| pct 100
            , lastChild
                [ borderRight2 (px 1) solid
                ]
            , hover
                [ color <| hex "666666"
                ]
            ]
        , class Genres
            [ color <| hex "adadad"
            , textTransform uppercase
            ]
        , desktop
            [ class HeaderContainer
                [ paddingLeft zero
                , paddingRight zero
                ]
            , class Genre
                [ borderBottom3 (px 2) solid transparent
                , withClass CurrentGenre
                    [ borderBottom3 (px 2) solid (hex "7ec57c")
                    ]
                ]
            , class Genres
                [ displayFlex
                , justifyContent spaceAround
                ]
            ]
        ]

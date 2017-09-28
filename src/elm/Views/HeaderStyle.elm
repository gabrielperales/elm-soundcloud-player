module Views.HeaderStyle exposing (css, Class(..))

import Css exposing (..)
import Css.Elements exposing (img)
import Css.Namespace exposing (namespace)
import Style.Colors exposing (colors)
import Style.Responsive exposing (tablet)


type Class
    = HeaderContainer
    | Logo
    | SearchField
    | SearchFieldInput


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
            [ display block
            , border zero
            , height <| pct 100
            , fontSize <| em 1
            ]
        , tablet
            [ class HeaderContainer
                [ paddingLeft zero
                , paddingRight zero
                ]
            ]
        ]

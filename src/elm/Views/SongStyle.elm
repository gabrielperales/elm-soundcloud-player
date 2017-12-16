module Views.SongStyle exposing (css, Class(..))

import Css exposing (..)
import Css.Namespace exposing (namespace)
import Style.Responsive exposing (tablet)
import Style.Colors exposing (colors)


type Class
    = Container
    | Image
    | Title
    | Username
    | Avatar
    | Main
    | PlayButton


css : Stylesheet
css =
    (stylesheet << namespace "song")
        [ class Container
            [ borderBottom3 (px 1) solid colors.lightGray
            , backgroundColor colors.nearWhite
            , boxSizing borderBox
            , cursor pointer
            ]
        , class Image
            [ marginRight <| em 0.5
            , height <| px 50
            , width <| px 50
            , flexShrink zero
            ]
        , class Title
            [ margin <| em 0.25
            , paddingBottom <| px 4
            , fontSize <| em 0.8
            , height <| em 1
            , lineHeight <| em 1.5
            , overflow hidden
            , textOverflow ellipsis
            , width <| pct 75
            ]
        , class Username
            [ fontSize <| em 0.75
            , color <| rgb 100 100 100
            ]
        , class Main
            [ displayFlex
            , alignItems center
            ]
        , class Avatar
            [ display none
            ]
        , class PlayButton
            [ display none
            ]
        , tablet
            [ class Container
                [ backgroundColor colors.white
                , border3 (px 1) solid colors.lightGray
                , maxWidth <| px 180
                , flexDirection column
                , padding <| em 0.5
                , margin <| em 0.5
                , marginLeft auto
                , marginRight auto
                ]
            , class Image
                [ width <| pct 100
                , height <| px 80
                , overflow hidden
                , boxSizing borderBox
                ]
            , class Main
                [ fontSize <| em 0.75
                , height <| px 30
                ]
            , class Avatar
                [ display block
                , width <| px 24
                , height <| px 24
                , backgroundSize cover
                , backgroundRepeat noRepeat
                , borderRadius <| pct 50
                , flexShrink zero
                , marginRight <| px 10
                ]
            , class PlayButton
                [ displayFlex
                , opacity zero
                , position relative
                , alignItems center
                , justifyContent center
                , backgroundColor <| rgba 0 0 0 0.3
                , width <| pct 100
                , height <| pct 100
                , color <| hex "7ec57c"
                , hover
                    [ opacity <| num 1 ]
                ]
            ]
        ]

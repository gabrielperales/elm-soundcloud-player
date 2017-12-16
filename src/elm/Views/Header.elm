module Views.Header exposing (view)

import Html exposing (Html, node, div, a, img, text, form, input)
import Html.Attributes as Attr exposing (type_, src, style)
import Html.Events exposing (onClick, onSubmit, onInput)
import Html.CssHelpers as CssHelpers
import Style.Global as Global exposing (globalClass)
import Views.HeaderStyle as Style
import Data.Genre as Genre exposing (Genre(..))
import Route exposing (Route(..), href)


{ class } =
    CssHelpers.withNamespace "header"


view : Genre -> (String -> msg) -> msg -> Html msg
view currentGenre changeSearch submit =
    div [ class [ Style.HeaderContainer ] ]
        [ div
            [ globalClass
                [ Global.Flex
                , Global.JustifySpaceBetween
                , Global.AlignItemsCenter
                , Global.Maxwidth
                , Global.DirectionRow
                , Global.H100
                ]
            ]
            [ a [ href Home, class [ Style.Logo ] ] [ img [ src "assets/elm_logo.png" ] [], text "sound-elm" ]
            , div [ class [ Style.SearchField ] ]
                [ form [ onSubmit submit ]
                    [ node "i" [ Attr.class "fa fa-search" ] []
                    , input [ type_ "text", class [ Style.SearchFieldInput ], onInput changeSearch ] []
                    ]
                ]
            ]
        , div [ class [ Style.GenresNav ] ]
            [ div [ class [ Style.Genres ], globalClass [ Global.Maxwidth ] ]
                (List.map
                    (\genre ->
                        let
                            classes =
                                [ Style.Genre ]
                                    ++ if genre == currentGenre then
                                        [ Style.CurrentGenre ]
                                       else
                                        []
                        in
                            a [ class classes, style [ ( "transition", "all .5s" ) ], href <| Genre genre ]
                                [ text <| Genre.genreToString genre ]
                    )
                    [ House, Chill, Deep, Dubstep, Progressive, Tech, Trance, Tropical ]
                )
            ]
        ]

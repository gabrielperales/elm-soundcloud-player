module Views.Header exposing (view)

import Html exposing (Html, node, div, a, img, text, form, input)
import Html.Attributes as Attr exposing (type_, src, href)
import Html.Events exposing (onClick, onSubmit, onInput)
import Html.CssHelpers as CssHelpers
import Style.Global as Global exposing (globalClass)
import Views.HeaderStyle as Style
import Data.Genre exposing (Genre(..))


{ class } =
    CssHelpers.withNamespace "header"


view : (String -> msg) -> (Genre -> msg) -> msg -> Html msg
view changeSearch changeGenre submit =
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
            [ a [ href "#", class [ Style.Logo ] ] [ img [ src "assets/elm_logo.png" ] [], text "sound-elm" ]
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
                        div [ class [ Style.Genre ], onClick <| changeGenre genre ] [ text <| toString genre ]
                    )
                    [ House, Chill, Deep, Dubstep, Progressive, Tech, Trance, Tropical ]
                )
            ]
        ]

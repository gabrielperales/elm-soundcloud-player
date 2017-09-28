module Views.Header exposing (view)

import Html exposing (Html, div, a, img, text, form, input)
import Html.Attributes exposing (type_, src, href)
import Html.Events exposing (onSubmit, onInput)
import Html.CssHelpers as CssHelpers
import Style.Global as Global exposing (globalClass)
import Views.HeaderStyle as Style


{ class } =
    CssHelpers.withNamespace "header"


view : (String -> msg) -> msg -> Html msg
view change submit =
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
                    [ input [ type_ "text", class [ Style.SearchFieldInput ], onInput change ] []
                    ]
                ]
            ]
        , div [] []
        ]

module Views.Header exposing (view)

import Html exposing (Html, div, text, input)
import Html.Attributes as Attr exposing (type_)
import Html.CssHelpers as CssHelpers
import Style.Global as Global exposing (globalClass)
import Views.HeaderStyle as Style


{ class } =
    CssHelpers.withNamespace "header"


view : Html msg
view =
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
            [ div [ class [ Style.Logo ] ] [ text "sound-elm" ]
            , div [ class [ Style.SearchField ] ]
                [ input [ type_ "text", class [ Style.SearchFieldInput ] ] []
                ]
            ]
        , div [ Attr.class "h2-l" ] []
        ]

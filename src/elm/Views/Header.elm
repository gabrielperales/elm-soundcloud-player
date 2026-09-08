module Views.Header exposing (view)

import Html exposing (Html, node, div, a, img, text, form, input)
import Html.Attributes as Attr exposing (type_, src, style, class, classList)
import Html.Events exposing (onClick, onSubmit, onInput)
import Data.Genre as Genre exposing (Genre(..))
import Route exposing (Route(..), href)


view : Maybe Genre -> Bool -> (String -> msg) -> msg -> msg -> Html msg
view currentGenre isMenuOpen changeSearch toggleMenu submit =
    let
        navClass =
            if isMenuOpen then
                "header-genres-nav is-open"

            else
                "header-genres-nav"
    in
    div [ class "header-container" ]
        [ div
            [ class "global-flex global-justify-space-between global-align-items-center global-maxwidth global-direction-row global-h100" ]
            [ a [ href Home, class "header-logo" ] [ img [ src "assets/elm_logo.png" ] [], text "sound-elm" ]
            , div [ class "header-search-field" ]
                [ form [ onSubmit submit ]
                    [ node "i" [ Attr.class "fa fa-search" ] []
                    , input [ type_ "text", class "header-search-field-input", onInput changeSearch ] []
                    ]
                ]
            ]
        , div [ class navClass, onClick toggleMenu ]
            [ div [ class "header-genres global-maxwidth" ]
                (List.map
                    (\genre ->
                        let
                            genreClass =
                                classList
                                    [ ( "header-genre", True )
                                    , ( "header-current-genre", Just genre == currentGenre )
                                    ]
                        in
                        a [ genreClass, href <| Genre genre ]
                            [ text <| Genre.genreToString genre ]
                    )
                    [ House, Chill, Deep, Dubstep, Progressive, Tech, Trance, Tropical ]
                )
            ]
        ]

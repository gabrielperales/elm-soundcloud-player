module Request.Song
    exposing
        ( Options
        , defaultOptions
        , query
        , tags
        , genres
        , limit
        , linked_partitioning
        , request
        )

import Data.Collection as Collection exposing (Collection)
import Http exposing (Request)


apiUrl : String
apiUrl =
    "http://api.soundcloud.com/"


type alias ClientId =
    String


type alias Options =
    { client_id : ClientId
    , q : Maybe String
    , tags : Maybe (List String)
    , genres : Maybe (List String)
    , limit : Maybe Int
    , linked_partitioning : Maybe Int
    }


defaultOptions : ClientId -> Options
defaultOptions clientId =
    { client_id = clientId
    , q = Nothing
    , tags = Nothing
    , genres = Nothing
    , limit = Nothing
    , linked_partitioning = Nothing
    }


query : String -> Options -> Options
query query options =
    { options | q = Just query }


tags : List String -> Options -> Options
tags tags options =
    { options | tags = Just tags }


genres : List String -> Options -> Options
genres genres options =
    { options | genres = Just genres }


limit : Int -> Options -> Options
limit limit options =
    { options | limit = Just limit }


linked_partitioning : Int -> Options -> Options
linked_partitioning page options =
    { options | linked_partitioning = Just page }


request : Options -> Request Collection
request options =
    let
        url =
            apiUrl
                ++ "tracks/?"
                ++ "client_id="
                ++ options.client_id
                ++ (Maybe.withDefault "" <|
                        Maybe.map ((++) "&q=") options.q
                   )
                ++ (Maybe.withDefault "" <|
                        Maybe.map ((++) "&genres=" << toString) options.genres
                   )
                ++ (Maybe.withDefault "" <|
                        Maybe.map ((++) "&tags=" << String.join ",") options.tags
                   )
                ++ (Maybe.withDefault "" <|
                        Maybe.map ((++) "&limit=" << toString) options.limit
                   )
                ++ (Maybe.withDefault "" <|
                        Maybe.map ((++) "&linked_partitioning=" << toString) options.linked_partitioning
                   )
    in
        Http.get url (Collection.decoder)

module Request.Song exposing
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
import Http


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
query query_ options =
    { options | q = Just query_ }


tags : List String -> Options -> Options
tags tags_ options =
    { options | tags = Just tags_ }


genres : List String -> Options -> Options
genres genres_ options =
    { options | genres = Just genres_ }


limit : Int -> Options -> Options
limit limit_ options =
    { options | limit = Just limit_ }


linked_partitioning : Int -> Options -> Options
linked_partitioning page options =
    { options | linked_partitioning = Just page }


buildUrl : Options -> String
buildUrl options =
    apiUrl
        ++ "tracks/?"
        ++ "client_id="
        ++ options.client_id
        ++ (Maybe.withDefault "" <|
                Maybe.map ((++) "&q=") options.q
           )
        ++ (Maybe.withDefault "" <|
                Maybe.map ((++) "&genres=" << String.join ",") options.genres
           )
        ++ (Maybe.withDefault "" <|
                Maybe.map ((++) "&tags=" << String.join ",") options.tags
           )
        ++ (Maybe.withDefault "" <|
                Maybe.map ((++) "&limit=" << String.fromInt) options.limit
           )
        ++ (Maybe.withDefault "" <|
                Maybe.map ((++) "&linked_partitioning=" << String.fromInt) options.linked_partitioning
           )


request : Options -> (Result Http.Error Collection -> msg) -> Cmd msg
request options toMsg =
    Http.get
        { url = buildUrl options
        , expect = Http.expectJson toMsg Collection.decoder
        }

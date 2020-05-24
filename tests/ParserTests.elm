module ParserTests exposing (suite)

import Expect exposing (Expectation)
import Json.Decode
import Json.Encode as Json
import JsonParserExample exposing (Address, Person, fromServerEncoder, personDecoder)
import Test exposing (..)


suite : Test
suite =
    describe "json parsers"
        [ describe "parse person" decodePersonTests ]


decodePersonTests : List Test
decodePersonTests =
    let
        fromServer =
            { firstName = "Barak", lastName = "Bar Orion", age = 50, address = "{\"city\" : \"Avigdor\", \"street\" : \"Yael\", \"house\": 40}" }

        strFromServer =
            Json.encode 2 <| fromServerEncoder fromServer

        _ =
            Debug.log "strFromServer" strFromServer
    in
    [ test "Properly decodes input from server " <|
        \() ->
            let
                decodedOutput =
                    Json.Decode.decodeString personDecoder strFromServer
            in
            Expect.ok decodedOutput
    ]

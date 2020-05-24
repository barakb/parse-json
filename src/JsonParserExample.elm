module JsonParserExample exposing (..)

import Json.Decode exposing (Decoder, andThen, errorToString, fail, int, string, succeed)
import Json.Decode.Pipeline exposing (required)
import Json.Encode as Json exposing (object)


type alias Address =
    { city : String, street : String, house : Int }


type alias Person =
    { firstName : String, lastName : String, age : Int, address : Address }


{-| Helper for generating a person with address as string, use `Json.encode 2 <| fromServerEncoder fromServer` to turn
a fromServer record to string in a format that received from the server.
-}
type alias FromServer =
    { firstName : String, lastName : String, age : Int, address : String }


fromServerEncoder : FromServer -> Json.Value
fromServerEncoder person =
    object
        [ ( "firstName", Json.string person.firstName )
        , ( "lastName", Json.string person.lastName )
        , ( "age", Json.int person.age )
        , ( "address", Json.string person.address )
        ]


addressDecoder : Decoder Address
addressDecoder =
    succeed Address
        |> required "city" string
        |> required "street" string
        |> required "house" int


personDecoder : Decoder Person
personDecoder =
    succeed Person
        |> required "firstName" string
        |> required "lastName" string
        |> required "age" int
        --First decode the string and than transform it to address record
        |> required "address" (string |> andThen addressDecoderFromString)


addressDecoderFromString : String -> Decoder Address
addressDecoderFromString str =
    case Json.Decode.decodeString addressDecoder str of
        Ok value ->
            succeed value

        Err error ->
            fail (errorToString error)

module Stock exposing (..)
import Json.Decode as Decode
import Html exposing (..)
import Html.Events exposing (onClick)

-- Model
type alias Stock =
  {
    symbol: String,
    history: List Point
  }

type alias Point =
  {
    date: String,
    value: Float
  }

-- Decode list of stocks
decodeStocks : String -> List Stock
decodeStocks message =
  Result.withDefault [] (Decode.decodeString (Decode.field "body" (Decode.list decodeStock)) message)

-- Decode individually sent stock
decodeNewStock : String -> Stock
decodeNewStock message =
  Result.withDefault (Stock "" []) (Decode.decodeString (Decode.field "body" decodeStock) message)


-- Decode stock from list
decodeStock : Decode.Decoder Stock
decodeStock =
  Decode.map2 Stock
    (Decode.field "symbol" Decode.string)
    (Decode.field "history" (Decode.list decodePoint))


-- Decode symbol from message
decodeSymbol : String -> String
decodeSymbol message =
  Result.withDefault "" (Decode.decodeString (Decode.field "body" Decode.string) message)

-- Decode point from stock
decodePoint : Decode.Decoder Point
decodePoint =
  Decode.map2 Point
    (Decode.field "date" Decode.string)
    (Decode.field "value" Decode.float)


-- Stock Card view component
view : String -> (String -> updater) -> Html updater
view symbol delete =
  div []
    [
      h1 []
        [ text symbol ],
      button [ onClick (delete symbol) ]
        [ text "X" ]
    ]

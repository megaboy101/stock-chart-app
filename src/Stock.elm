module Stock exposing (..)
import Json.Decode as Decode
import Html exposing (Html, li, span, text, button)
import Html.Events exposing (onClick)
import Html.Attributes exposing (style, class)

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
view : String -> String -> (String -> updater) -> Html updater
view symbol colorHex delete =
  li [ class "slide", style [("font-size", "70px"), ("color", colorHex)] ]
    [
      text "●",
      span [ class "f3 b avenir dark-gray pl2", style [("vertical-align", "middle")] ] [ text symbol ],
      button [ onClick (delete symbol), class "bn bg-white b dark-gray f4 ml5 pointer", style [("vertical-align", "middle")] ] [ text "x" ]
    ]

module Sockets exposing (..)
import Json.Decode as Decode
import Json.Encode as Encode
import Stock exposing (Stock, decodeStocks, decodeNewStock, decodeSymbol)

type alias RawMessage = String

updateBySocket : RawMessage -> { app | stocks : List Stock } -> ({ app | stocks : List Stock }, Cmd updater)
updateBySocket message app =
  case (decodeAction message) of
    "initLoad" ->
      { app | stocks = (decodeStocks message) } ! []
    "addStock" ->
      { app | stocks = List.append app.stocks [(decodeNewStock message)] } ! []
    "removeStock" ->
      { app | stocks = List.filter (\stock -> stock.symbol /= (decodeSymbol message)) app.stocks } ! []
    _ ->
      let
        result = Debug.log "error" (decodeAction message)
      in
        app ! []


decodeAction : RawMessage -> String
decodeAction message =
  Result.withDefault "" (Decode.decodeString (Decode.field "action" Decode.string) message)

encodeSearch : String -> String
encodeSearch query =
  Encode.encode 0 (Encode.object [("action", Encode.string "search"), ("body", Encode.string query)])

encodeSymbol : String -> String
encodeSymbol symbol =
  Encode.encode 0 (Encode.object [("action", Encode.string "remove"), ("body", Encode.string symbol)])

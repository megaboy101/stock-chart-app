module Sockets exposing (..)
import Json.Decode as Decode
import Json.Encode as Encode
import Portal exposing (loadChart)
import Stock exposing (Stock, decodeStocks, decodeNewStock, decodeSymbol)

type alias RawMessage = String

updateBySocket : RawMessage -> { app | stocks : List Stock, inputPlaceholder : String } -> ({ app | stocks : List Stock, inputPlaceholder : String }, Cmd updater)
updateBySocket message app =
  case (decodeAction message) of
    "initLoad" ->
      let
        newStockList = decodeStocks message
      in
        { app | stocks = newStockList, inputPlaceholder = "" } ! [ loadChart newStockList ]
    "addStock" ->
      let
        newStockList = List.append app.stocks [(decodeNewStock message)]
      in
        { app | stocks = newStockList, inputPlaceholder = "" } ! [ loadChart newStockList ]
    "removeStock" ->
      let
        newStockList = List.filter (\stock -> stock.symbol /= (decodeSymbol message)) app.stocks
      in
        { app | stocks = newStockList, inputPlaceholder = "" } ! [ loadChart newStockList ]
    "stockNotFound" ->
      { app | inputPlaceholder = "Stock not found!" } ! []
    _ ->
      let
        result = Debug.log "error" (decodeAction message)
      in
        { app | inputPlaceholder = "Error, sorry :("} ! []


decodeAction : RawMessage -> String
decodeAction message =
  Result.withDefault "" (Decode.decodeString (Decode.field "action" Decode.string) message)

encodeSearch : String -> String
encodeSearch query =
  Encode.encode 0 (Encode.object [("action", Encode.string "search"), ("body", Encode.string query)])

encodeSymbol : String -> String
encodeSymbol symbol =
  Encode.encode 0 (Encode.object [("action", Encode.string "remove"), ("body", Encode.string symbol)])

module Sockets exposing (..)
import Json.Decode as Decode
import Json.Encode as Encode
import Portal exposing (loadChart)
import Stock exposing (Stock, decodeStocks, decodeNewStock, decodeSymbol)

type alias RawMessage = String

updateBySocket : RawMessage -> { app | stocks : List Stock } -> ({ app | stocks : List Stock }, Cmd updater)
updateBySocket message app =
  case (decodeAction message) of
    "initLoad" ->
      let
        newStockList = decodeStocks message
      in
        { app | stocks = newStockList } ! [ loadChart newStockList ]
    "addStock" ->
      let
        newStockList = List.append app.stocks [(decodeNewStock message)]
      in
        { app | stocks = newStockList } ! [ loadChart newStockList ]
    "removeStock" ->
      let
        newStockList = List.filter (\stock -> stock.symbol /= (decodeSymbol message)) app.stocks
      in
        { app | stocks = newStockList } ! [ loadChart newStockList ]
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

module Main exposing (..)
import Html exposing (Html, text, h1, div, nav, input, button, ul, li)
import Html.Events exposing (onInput, onClick)
import Html.Attributes exposing (value, id, class, style)
import WebSocket
import Updates exposing (Updater(..))
import Stock exposing (Stock)
import Sockets exposing (updateBySocket, encodeSearch, encodeSymbol)


main : Program Never App Updater
main =
  Html.program { init = init, view = view, update = update, subscriptions = subscriptions }


-- Model
type alias App =
  {
    input : String,
    loading : Bool,
    stocks : List Stock
  }

init : (App, Cmd Updater)
init =
  (App "" False [], Cmd.none)


-- Update
update : Updater -> App -> (App, Cmd Updater)
update updater app =
  case updater of
    UpdateInput input ->
      { app | input = input } ! []
    SearchStock ->
      let
        query = app.input
        symbols = List.map (\stock -> stock.symbol) app.stocks
      in
        if (query /= "") && ((List.member query symbols) == False) then
          { app | input = "" } ! [ WebSocket.send "ws://localhost:3000" (encodeSearch app.input) ]
        else
          app ! []
    RemoveStock symbol ->
      app ! [ WebSocket.send "ws://localhost:3000" (encodeSymbol symbol) ]
    ReceivedSocket json ->
      updateBySocket json app


-- Subscriptions
subscriptions : App -> Sub Updater
subscriptions app =
  Sub.batch
    [ WebSocket.listen "ws://localhost:3000" ReceivedSocket ]


-- View
view : App -> Html Updater
view app =
  div []
    [
      input [ onInput UpdateInput, value app.input ]
        [],
      button [ onClick SearchStock ]
        [ text "Submit" ],
      ul []
        ( List.map (\stock -> li [] [ Stock.view stock.symbol RemoveStock ]) app.stocks ),

      div [ id "chart", style [("width", "100%"), ("height", "400px")]]
        []
    ]


  -- div []
  --   [
  --     button [ class "toggleNav" ]
  --       [],
  --
  --   ]

module Main exposing (..)
import Html exposing (Html, text, h1, div, span, section, input, button, ul, li, br)
import Html.Events exposing (onInput, onClick)
import Html.Attributes exposing (value, placeholder, id, class, style)
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
    inputPlaceholder : String,
    stocks : List Stock
  }

init : (App, Cmd Updater)
init =
  (App "" "Loading..." [], Cmd.none)


-- Update
update : Updater -> App -> (App, Cmd Updater)
update updater app =
  case updater of
    UpdateInput input ->
      { app | input = String.toUpper input } ! []
    SearchStock ->
      let
        query = app.input
        symbols = List.map (\stock -> stock.symbol) app.stocks
      in
        if (query == "") then
          { app | inputPlaceholder = "Input a stock first!", input = "" } ! []
        else if (List.member query symbols) == True then
          { app | inputPlaceholder = "That stock already exists!", input = "" } ! []
        else
          { app | input = "", inputPlaceholder = "Loading..." } ! [ WebSocket.send "ws://megaboy-market-lounge.herokuapp.com" (encodeSearch app.input) ]
    RemoveStock symbol ->
      app ! [ WebSocket.send "ws://megaboy-market-lounge.herokuapp.com" (encodeSymbol symbol) ]
    ReceivedSocket json ->
      updateBySocket json app


-- Subscriptions
subscriptions : App -> Sub Updater
subscriptions app =
  Sub.batch
    [ WebSocket.listen "ws://megaboy-market-lounge.herokuapp.com" ReceivedSocket ]


-- View
view : App -> Html Updater
view app =
  let
    colors = [ "#d70206", "#f05b4f", "#f4c63d",
                "#d17905", "#453d3f", "#59922b", "#0544d3",
                "#6b0392", "#f05b4f", "#dda458", "#eacf7d",
                "#86797d", "#b2c326", "#6188e2", "#a748ca" ]
  in
    div [ class "flex-l flex-row-l pv3 ph5 vh-100" ]
      [
        section [ class "w-33-l h-100-l" ]
          [
            h1 [ class "w-10 f1 avenir dark-gray" ]
              [ text "Market Lounge" ],
            div [ class "input" ]
              [
                input [ class " f5 ba b b--dark-gray bw2 pa1 dark-gray", onInput UpdateInput, value app.input, placeholder app.inputPlaceholder ]
                  [],
                br [] [],
                button [ class "bn bg-white b dark-gray mv3 pa0 f4 pointer", onClick SearchStock ]
                  [ text "Submit" ]
              ],
            ul [ class "list pl0 flex flex-row flex-wrap flex-column-l" ]
              ( List.map2 stockDoubleMapper colors app.stocks )
          ],
        div [ class "flex items-center justify-end w-100 h-100-l"]
          [
            div [ class "w-100 h-75-l h-fix", id "chart" ]
              []
          ]
      ]


stockDoubleMapper : String -> Stock -> Html Updater
stockDoubleMapper colorHex stock =
  Stock.view stock.symbol colorHex RemoveStock

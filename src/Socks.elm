module Socks exposing (..)

import Html exposing (div, button, text, Html, program)
import Html.Events exposing (onClick)
import WebSocket
import Portal


-- Example reference for web sockets

type alias Model =
  {
    message: String
  }

init : (Model, Cmd Action)
init =
  Model "Greetings from Elm" ! []


view : Model -> Html Action
view model =
  div []
    [
      text (toString model.message),
      button [ onClick SendSocket ]
        [ text "Send WebSocket" ]
    ]


type Action
  = SendSocket
  | ReceivedSocket String

update: Action -> Model -> (Model, Cmd Action)
update action model =
  case action of
    SendSocket ->
      model ! [WebSocket.send "ws://localhost:3000" "Is anyone out there?"]
    ReceivedSocket message ->
      { model | message = message } ! []


subscriptions : Model -> Sub Action
subscriptions model =
  Sub.batch
    WebSocket.listen "ws://localhost:3000" ReceivedSocket

module Main exposing (..)

import Html exposing (div, text, Html, beginnerProgram)
import Html.Events exposing (onClick)

main: Program Never Int Action
main =
  beginnerProgram { model = model, view = view, update = update }


model : Int
model =
  0


view : Int -> Html Action
view model =
  div [ onClick Increment ]
    [ text (toString model) ]


type Action = Increment

update: Action -> Int -> Int
update action model =
  case action of
    Increment ->
      model + 1

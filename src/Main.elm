module Main exposing (..)
import Html exposing (..)


main : Program Never Model Action
main =
  program { init = init, view = view, update = update, subscriptions = subscriptions }


-- Model
type alias Model =
  {
    
  }

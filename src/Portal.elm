port module Portal exposing (..)
import Stock exposing (Stock)

port loadChart : List Stock -> Cmd updater

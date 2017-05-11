module Updates exposing (..)

type Updater
  = UpdateInput String
  | SearchStock
  | RemoveStock String
  | ReceivedSocket String

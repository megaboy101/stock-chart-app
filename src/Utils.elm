module Utils exposing (..)
import Stock exposing (Stock)

updateStockId : String -> List Stock -> List Stock
updateStockId stockId stocks =
  List.map (\stock -> if stock.id == stockId then stock.)

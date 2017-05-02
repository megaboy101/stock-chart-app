port module Portal exposing (outbound, inbound)


port outbound : String -> Cmd message


port inbound : (String -> action) -> Sub action

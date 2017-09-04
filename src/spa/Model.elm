module Spa.Model exposing (..)


type Msg
    = Test


type alias Model =
    { text : String
    , num : Int
    }


initialModel : Model
initialModel =
    Model "a" 0

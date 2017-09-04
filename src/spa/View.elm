module Spa.View exposing (..)

import Spa.Model exposing (..)
import Html exposing (Html, div, h1, text)
import Html.Attributes exposing (class)


view : Model -> Html Msg
view model =
    div []
        [ h1 []
            [ text "Home" ]
        , div
            [ class "messages" ]
            [ text model.text ]
        ]

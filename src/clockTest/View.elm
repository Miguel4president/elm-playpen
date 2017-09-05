module ClockTest.View exposing (display)

import ClockTest.Physics exposing (..)
import ClockTest.Model exposing (Model, Msg(..))
import Html exposing (Html, button, div, p, br, text, span, Attribute)
import Svg exposing (..)
import Svg.Attributes exposing (..)


display : Physics -> Html Msg
display physics =
    div []
        [ div [] [ Html.text "hello" ]
        , div [] [ Html.text <| "Velocity: " ++ (toString physics.velocity) ]
        , div [] [ Html.text <| "Position: " ++ (toString physics.location) ]
        , div [] [ Html.text <| "Keys: " ++ (toString physics.keys) ]
        , br [] []
        , simpleContainer physics
        ]


simpleContainer : Physics -> Html Msg
simpleContainer physics =
    div [ class "play-zone" ]
        [ Svg.svg [ Svg.Attributes.viewBox "0 0 100 100", Svg.Attributes.width "300px" ]
            [ circle [ cx "50", cy "50", r "5", stroke "blue", fill "blue" ] []
            ]
        ]

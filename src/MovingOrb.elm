module MovingOrb exposing (movingOrb)

{-| @docs MovingOrb
-}

import Html exposing (Html, Attribute)
import Svg exposing (..)
import Svg.Attributes exposing (..)


movingOrb : Int -> Int -> Html msg
movingOrb velocityX velocityY =
    -- svg coords are from 0 - 100, but box is actually 300 px
    Svg.svg [ Svg.Attributes.viewBox "0 0 100 100", Svg.Attributes.width "300px" ]
        [ circle [ cx "50", cy "50", r "5", stroke "blue", fill "blue" ] []
        , trail velocityX velocityY
        ]



-- Longest and straight


centerLine : Int -> Int -> Svg msg
centerLine velocityX velocityY =
    line
        [ x1 "50"
        , y1 "50"
        , x2 (toString <| 50 + (velocityX * 2))
        , y2 (toString <| 50 - (velocityY * 2))
        , stroke "blue"
        ]
        []


trail : Int -> Int -> Svg msg
trail velocityX velocityY =
    line
        [ x1 "50"
        , y1 "50"
        , x2 (toString <| 50 + (velocityX * -2))
        , y2 (toString <| 50 + (velocityY * 2))
        , stroke "blue"
        ]
        []



-- shorter and off to the side


leftLine : Int -> Int -> Svg msg
leftLine velocityX velocityY =
    let
        ( xOffset, yOffset ) =
            ( 50 + ((getDirection velocityX) * 2)
            , 50 - ((getDirection velocityY) * 2)
            )
    in
        line
            [ x1 (toString <| xOffset)
            , y1 (toString <| yOffset)
            , x2 (toString <| 50 + velocityX)
            , y2 (toString <| 50 - velocityY)
            , stroke "blue"
            ]
            []


transformLine : Int -> Int -> Svg msg
transformLine velocityX velocityY =
    -- Simple line 10 units long
    line
        [ x1 "50"
        , y1 "50"
        , x2 (toString <| 50 + (vectorMagnitude velocityX velocityY))
        , y2 "50"
        , stroke "blue"
        , transform ("rotate(" ++ (toString (vectorAngle velocityX velocityY)) ++ " 50 50)")
        ]
        []


getDirection : Int -> Int
getDirection num =
    num // (abs num)



-- This is pythag


vectorMagnitude : Int -> Int -> Float
vectorMagnitude velocityX velocityY =
    (velocityX ^ 2)
        + (velocityY ^ 2)
        |> toFloat
        |> sqrt


vectorAngle : Int -> Int -> Float
vectorAngle velocityX velocityY =
    radians <| atan2 (toFloat velocityY) (toFloat velocityX)

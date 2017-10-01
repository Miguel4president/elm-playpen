module ClockTest.AcceleratingMotion exposing (..)

{-| @docs AcceleratingMotion
Fxns & model for handling an object with
position, motion, & acceleration

Velocity -> Units / second
Acceleration -> Units / second^2

-}

-- import Time exposing (Time)
-- TYPES


acceleration : Float
acceleration =
    1


type alias MovingObject =
    { location : Location
    , vector : Vector
    }



-- A vector has direction and magnitude (dx, dy) or (theta, mag)


type alias Vector =
    { dx : Magnitude
    , dy : Magnitude
    }


type alias Location =
    { x : Float
    , y : Float
    }


type Magnitude
    = Magnitude Float



-- nextPosition : MovingObject -> MovingObject
-- nextPosition { location, vector } =
--   let
--       newPosition =
--         { location | x = location.x + vector.x}
--   in

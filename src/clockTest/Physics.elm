module ClockTest.Physics exposing (Physics, init, update, updateKeys, Key(..))

import Time exposing (Time)
import Char exposing (fromCode)


{-| @docs Physics
functions for handling the key press states
How to change position and velocity

Velocity -> Units / second
Acceleration -> Units / second^2

-}



-- TYPES


type alias Physics =
    { location : Location
    , velocity : Velocity
    , acceleration : Float
    , keys : Keys
    }


type alias Location =
    { x : Float
    , y : Float
    }


type alias Velocity =
    { dx : Float
    , dy : Float
    }


type Key
    = Down Int
    | Up Int


type alias Keys =
    { down : Bool
    , left : Bool
    , right : Bool
    , up : Bool
    }


init : Physics
init =
    { location = Location 0 0
    , velocity = Velocity 0 0
    , acceleration = 1
    , keys = Keys False False False False
    }



-- UPDATES


update : Time -> Physics -> Physics
update timeDelta current =
    current
        |> updateLocation timeDelta
        |> updateVelocity timeDelta


updateLocation : Time -> Physics -> Physics
updateLocation timeDelta ({ location, velocity } as current) =
    let
        newX =
            location.x + (velocity.dx * timeDelta)

        newY =
            location.y + (velocity.dy * timeDelta)
    in
        { current | location = Location newX newY }


updateVelocity : Time -> Physics -> Physics
updateVelocity timeDelta ({ velocity, acceleration, keys } as current) =
    let
        affectOfAcceleration =
            acceleration * timeDelta

        newDx =
            velocity.dx
                |> addIfTrue keys.right affectOfAcceleration
                |> addIfTrue keys.left (affectOfAcceleration * -1)

        newDy =
            velocity.dy
                |> addIfTrue keys.up affectOfAcceleration
                |> addIfTrue keys.down (affectOfAcceleration * -1)
    in
        { current | velocity = Velocity newDx newDy }



-- SETTERS!


updateKeys : Key -> Physics -> Physics
updateKeys key ({ keys } as current) =
    case key of
        Down keyCode ->
            { current | keys = applyKeyChange keyCode True keys }

        Up keyCode ->
            { current | keys = applyKeyChange keyCode False keys }


applyKeyChange : Int -> Bool -> Keys -> Keys
applyKeyChange keyCode pressed currentKeys =
    case fromCode keyCode of
        'A' ->
            { currentKeys | left = pressed }

        'W' ->
            { currentKeys | up = pressed }

        'S' ->
            { currentKeys | down = pressed }

        'D' ->
            { currentKeys | right = pressed }

        -- For some reason, we don't catch arrow keys...growl
        _ ->
            currentKeys



-- HELPERS!
-- I would like type safety here, like these floats are Delta and Velocity types


addIfTrue : Bool -> Float -> Float -> Float
addIfTrue isTrue delta current =
    if isTrue then
        current + delta
    else
        current

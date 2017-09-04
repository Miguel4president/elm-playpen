module ClockTest.Physics exposing (Physics, init, update, keyDown, keyUp)

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
    = Down
    | Left
    | None
    | Right
    | Up


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



-- Updates


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

        newLocation =
            Location newX newY
    in
        { current | location = newLocation }


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

        newVelocity =
            Velocity newDx newDy
    in
        { current | velocity = newVelocity }



-- SETTERS!


keyDown : Int -> Physics -> Physics
keyDown keyNum ({ keys } as current) =
    let
        key =
            interpretKey keyNum

        newKeys =
            updateKeys key True keys
    in
        { current | keys = newKeys }


keyUp : Int -> Physics -> Physics
keyUp keyNum ({ keys } as current) =
    let
        key =
            interpretKey keyNum

        newKeys =
            updateKeys key False keys
    in
        { current | keys = newKeys }


updateKeys : Key -> Bool -> Keys -> Keys
updateKeys key pressed currentKeys =
    case key of
        Down ->
            { currentKeys | down = pressed }

        Left ->
            { currentKeys | left = pressed }

        Right ->
            { currentKeys | right = pressed }

        Up ->
            { currentKeys | up = pressed }

        None ->
            currentKeys


interpretKey : Int -> Key
interpretKey keyCode =
    case fromCode keyCode of
        'A' ->
            Left

        'W' ->
            Up

        'S' ->
            Down

        'D' ->
            Right

        -- For some reason, we don't catch arrow keys...growl
        _ ->
            None



-- HELPERS!
-- I would like type safety here, like these floats are Delta and Velocity types


addIfTrue : Bool -> Float -> Float -> Float
addIfTrue isTrue delta current =
    if isTrue then
        current + delta
    else
        current

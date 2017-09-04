module ClockTest.Main exposing (..)

import AnimationFrame


-- import Char exposing (fromCode)

import Clock exposing (Clock)
import Html exposing (Html, button, div, p, text, span, Attribute)


-- import Html.Attributes exposing (..)
-- import Html.Events exposing (keyCode, on, onClick)
-- import Json.Decode as Json

import Keyboard exposing (..)
import ClockTest.Physics as Physics
import Time exposing (Time)


-- 30 FPS


gameLoopPeriod : Time.Time
gameLoopPeriod =
    33 * Time.millisecond


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    -- Limitations of key press
    -- Can't handle multiple keys at once, can't do hold and add another key
    Sub.batch
        [ Keyboard.downs KeyDown
        , Keyboard.ups KeyUp
        , AnimationFrame.diffs TimeDelta
        ]



-- MODEL


type alias Model =
    { clock : Clock
    , physics : Physics.Physics
    }


init : ( Model, Cmd Msg )
init =
    { clock = Clock.withPeriod gameLoopPeriod
    , physics = Physics.init
    }
        ! []



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        TimeDelta dt ->
            let
                ( clock, physics ) =
                    Clock.update Physics.update dt model.clock model.physics
            in
                { model
                    | clock = clock
                    , physics = physics
                }
                    ! []

        KeyDown keyNum ->
            let
                newPhysics =
                    Physics.keyDown keyNum model.physics
            in
                { model | physics = newPhysics } ! []

        KeyUp keyNum ->
            let
                newPhysics =
                    Physics.keyUp keyNum model.physics
            in
                { model | physics = newPhysics } ! []


type Msg
    = KeyDown Int
    | KeyUp Int
    | TimeDelta Time



-- update : Msg -> Model -> ( Model, Cmd Msg )
-- update msg model =
--     case msg of
--         -- Convert to key down and keyup then on tick add values
--         KeyPress keyCode ->
--             ( interpretKey keyCode model, Cmd.none )
-- VIEW
-- interpretKey : Int -> Model -> Model
-- interpretKey keyCode model =
--     case fromCode keyCode of
--         'a' ->
--             { model | velocityX = (increaseVelocity model.velocityX -1) }
--         'w' ->
--             { model | velocityY = (increaseVelocity model.velocityY 1) }
--         's' ->
--             { model | velocityY = (increaseVelocity model.velocityY -1) }
--         'd' ->
--             { model | velocityX = (increaseVelocity model.velocityX 1) }
--         -- For some reason, we don't catch arrow keys...growl
--         _ ->
--             model


increaseVelocity : Int -> Int -> Int
increaseVelocity lastVelocity additionalVelocity =
    let
        newVelocity =
            lastVelocity + additionalVelocity
    in
        if (abs newVelocity) > 20 then
            lastVelocity
        else
            newVelocity


view : Model -> Html Msg
view model =
    div []
        [ div [] [ text "hello" ]
        , div [] [ text <| "Velocity: " ++ (toString model.physics.velocity) ]
        , div [] [ text <| "Position: " ++ (toString model.physics.location) ]
        , div [] [ text <| "Keys: " ++ (toString model.physics.keys) ]
        ]

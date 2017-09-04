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
                    Physics.updateKeys (Physics.Down keyNum) model.physics
            in
                { model | physics = newPhysics } ! []

        KeyUp keyNum ->
            let
                newPhysics =
                    Physics.updateKeys (Physics.Up keyNum) model.physics
            in
                { model | physics = newPhysics } ! []


type Msg
    = KeyDown Int
    | KeyUp Int
    | TimeDelta Time


view : Model -> Html Msg
view model =
    div []
        [ div [] [ text "hello" ]
        , div [] [ text <| "Velocity: " ++ (toString model.physics.velocity) ]
        , div [] [ text <| "Position: " ++ (toString model.physics.location) ]
        , div [] [ text <| "Keys: " ++ (toString model.physics.keys) ]
        ]

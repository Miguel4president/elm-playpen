module ClockTest.Main exposing (..)

import AnimationFrame
import Clock exposing (Clock)
import ClockTest.Model exposing (Model, init, Msg(..))
import ClockTest.View exposing (display)
import Html exposing (Html)
import Keyboard exposing (..)
import ClockTest.Physics as Physics


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


view : Model -> Html Msg
view model =
    display model.physics

module ClockTest.Model exposing (..)

import Clock exposing (Clock)
import ClockTest.Physics as Physics
import Time exposing (Time)


-- 30 FPS


gameLoopPeriod : Time.Time
gameLoopPeriod =
    33 * Time.millisecond


type Msg
    = KeyDown Int
    | KeyUp Int
    | TimeDelta Time


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

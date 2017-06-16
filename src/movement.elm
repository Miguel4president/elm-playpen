module Main exposing (..)

import Html exposing (Html, button, div, p, text, span, Attribute)
import Html.Events exposing (keyCode, on, onClick)
import Keyboard exposing (..)
import Char exposing (fromCode)
import Json.Decode as Json
import Html.Attributes exposing (..)
import Random


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


init : ( Model, Cmd Msg )
init =
    ( Model 0 0, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    -- Lamda to accept keyCode and convert it to a character
    Keyboard.presses KeyPress



-- MODEL


type alias Model =
    { velocityX : Int
    , velocityY : Int
    }


model : Model
model =
    Model 0 0



-- UPDATE


type Msg
    = KeyPress Int
    | Kick
    | NewVelocity Int


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        -- Convert to key down and keyup then on tick add values
        KeyPress keyCode ->
            ( interpretKey keyCode model, Cmd.none )

        Kick ->
            ( model, Random.generate NewVelocity (Random.int 1 6) )

        NewVelocity newVelocity ->
            ( Model newVelocity newVelocity, Cmd.none )



-- VIEW


interpretKey : Int -> Model -> Model
interpretKey keyCode model =
    case fromCode keyCode of
        'a' ->
            { model | velocityX = model.velocityX - 1 }

        'w' ->
            { model | velocityY = model.velocityY + 1 }

        's' ->
            { model | velocityY = model.velocityY - 1 }

        'd' ->
            { model | velocityX = model.velocityX + 1 }

        -- For some reason, we don't catch arrow keys...growl
        _ ->
            model


view : Model -> Html Msg
view model =
    div []
        [ div
            [ class "top-buffer", style [ ( "padding", "70px 0" ) ] ]
            [ squareDiv (velocityString model) 50
            , button [ onClick Kick ] [ text "Kick" ]
            ]
        ]


velocityString : Model -> String
velocityString model =
    "{" ++ toString model.velocityX ++ ", " ++ toString model.velocityY ++ "}"


squareDiv : String -> Int -> Html Msg
squareDiv content size =
    div
        [ class "square"
        , style
            [ ( "width", toString size ++ "px" )
            , ( "height", toString size ++ "px" )
            , ( "margin", "auto" )
            , ( "background-color", "blue" )
            ]
        ]
        [ span
            [ style
                [ ( "text-align", "center" )
                , ( "width", "50%" )
                , ( "margin", "auto" )
                ]
            ]
            [ p [ style [ ( "padding", "15px 0" ), ( "color", "white" ) ] ] [ text content ] ]
        ]


onKeyUp : (Int -> msg) -> Attribute msg
onKeyUp tagger =
    on "keyup" (Json.map tagger keyCode)

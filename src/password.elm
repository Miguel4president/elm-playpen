module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)
import String
import List


main =
    Html.beginnerProgram { model = model, view = view, update = update }



-- MODEL


type alias Model =
    { name : String
    , password : String
    , passwordAgain : String
    }


model : Model
model =
    Model "" "" ""



-- UPDATE


type Msg
    = Name String
    | Password String
    | PasswordAgain String


update : Msg -> Model -> Model
update msg model =
    case msg of
        Name name ->
            { model | name = name }

        Password password ->
            { model | password = password }

        PasswordAgain password ->
            { model | passwordAgain = password }



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ input [ type_ "text", placeholder "Name", onInput Name ] []
        , input [ type_ "password", placeholder "Password", onInput Password ] []
        , input [ type_ "password", placeholder "Re-enter Password", onInput PasswordAgain ] []
        , passwordValidation model
        ]


viewValidation : Model -> Html msg
viewValidation model =
    let
        ( color, message ) =
            if model.password == model.passwordAgain then
                ( "green", "OK" )
            else
                ( "red", "Passwords do not match!" )
    in
        div [ style [ ( "color", color ) ] ] [ text message ]


passwordMatch : List String -> Model -> List String
passwordMatch errors model =
    if model.password /= model.passwordAgain then
        "Passwords do not match!" :: errors
    else
        errors


validationColor : List String -> String
validationColor errors =
    if List.isEmpty errors then
        "green"
    else
        "red"


validationMessage : List String -> String
validationMessage errors =
    if List.isEmpty errors then
        "Okay!"
    else
        String.join "," errors


passwordValidation : Model -> Html msg
passwordValidation model =
    let
        errors =
            passwordMatch [] model
    in
        div [ style [ ( "color", validationColor errors ) ] ] [ text (validationMessage errors) ]

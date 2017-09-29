module Main exposing (..)

import Html exposing (Html, button, div, text, input, br)
import Html.Attributes exposing (type_, placeholder, value)
import Html.Events exposing (onInput)


main =
    Html.beginnerProgram { model = model, view = view, update = update }


type alias Model =
    { input : String }


model : Model
model =
    { input = "" }


type Msg
    = UpdateInput String


update : Msg -> Model -> Model
update msg model =
    case msg of
        UpdateInput newInput ->
            { model | input = newInput }


type Markov
    = Markov String Int


type Prediction
    = Prediction String Int Markov


buildMarkov : String -> Int -> Markov
buildMarkov string int =
    Markov string int


predictSingle : String -> Int -> Markov -> Maybe Prediction
predictSingle string int markov =
    if int < 4 then
        Just (Prediction string int markov)
    else
        Nothing


createPrediction : String -> Maybe ( Int, Maybe Prediction )
createPrediction input =
    [ 6, 5, 4, 3, 2, 1 ]
        |> List.map (\order -> ( order, buildMarkov input order ))
        |> List.map (\( order, markov ) -> ( order, predictSingle input order markov ))
        |> List.filter
            (\( order, prediction ) ->
                case prediction of
                    Nothing ->
                        False

                    Just _ ->
                        True
            )
        |> List.head


view : Model -> Html Msg
view model =
    let
        manyMaybePrediction =
            createPrediction model.input
    in
        div []
            [ text " Here be text "
            , myInput model.input
            , text "and here be the current prediction:"
            , br [] []
            , handleManyMaybes manyMaybePrediction
            ]


myInput : String -> Html Msg
myInput val =
    input
        [ onInput UpdateInput
        , type_ "text"
        , placeholder "Input here"
        , value val
        ]
        []


handleManyMaybes : Maybe ( Int, Maybe Prediction ) -> Html Msg
handleManyMaybes maybeKeyedMaybePrediction =
    case maybeKeyedMaybePrediction of
        Just ( order, maybePred ) ->
            case maybePred of
                Just pred ->
                    div []
                        [ text "Fuck yeah, a prediction!"
                        , displayPrediction pred
                        ]

                Nothing ->
                    div [] [ text "frick, an order, but no prediction within" ]

        Nothing ->
            div [] [ text "frick, not keyed prediction" ]


displayPrediction : Prediction -> Html Msg
displayPrediction (Prediction string int markov) =
    div []
        [ text "Current prediction: "
        , br [] []
        , br [] []
        , text string
        , text "    "
        , text <| toString int
        , text "    "
        , text "a markov"
        ]

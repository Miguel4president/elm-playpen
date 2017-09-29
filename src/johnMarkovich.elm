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



-- Filter map and extracted fxns


predLength : Prediction -> Int
predLength (Prediction string _ _) =
    String.length string


inputIntoPrediction : String -> Int -> Maybe Prediction
inputIntoPrediction input order =
    order
        |> buildMarkov input
        |> predictSingle input order


createPrediction2 : String -> Maybe Prediction
createPrediction2 input =
    [ 6, 5, 4, 3, 2, 1 ]
        |> List.filterMap (inputIntoPrediction input)
        |> List.sortBy predLength
        |> List.head



-- Get your fold on!
-- neva' ulewais


emptyPrediction : Prediction
emptyPrediction =
    Prediction "" 0 (Markov "" 0)


createPrediction3 : String -> Prediction
createPrediction3 input =
    [ 6, 5, 4, 3, 2, 1 ]
        |> List.filterMap (inputIntoPrediction input)
        |> List.foldr always emptyPrediction


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

        createPred2Result =
            createPrediction2 model.input

        createPred3Result =
            createPrediction3 model.input
    in
        div []
            [ text " Here be text "
            , myInput model.input
            , text "and here be the current prediction:"
            , br [] []
            , handleManyMaybes manyMaybePrediction
            , br [] []
            , br [] []
            , text "A test of the createPrediction2 function: "
            , singleMaybePred createPred2Result
            , br [] []
            , br [] []
            , text "A test of the createPrediction3 function: "
            , notEvenMaybePred createPred3Result
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


notEvenMaybePred : Prediction -> Html Msg
notEvenMaybePred pred =
    div []
        [ text "We always get a prediction."
        , displayPrediction pred
        ]


singleMaybePred : Maybe Prediction -> Html Msg
singleMaybePred mPred =
    mPred
        |> Maybe.map displayPrediction
        |> Maybe.withDefault (div [] [ text "Rats, didn't get a prediction" ])


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

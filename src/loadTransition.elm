module Main exposing (..)

import Html exposing (Html, button, div, text)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)


main =
    Html.beginnerProgram { model = model, view = view, update = update }



-- MODEL


type alias Model =
    { data : Maybe (List String)
    }


model : Model
model =
    { data = Nothing }



-- UPDATE


type Msg
    = Load
    | Reset


update : Msg -> Model -> Model
update msg model =
    case msg of
        Load ->
            { model | data = Just [ "yes", "no", "data", "loaded" ] }

        Reset ->
            { model | data = Nothing }



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ button [ onClick Load ] [ text "Load" ]
        , div [] [ text (toString model) ]
        , button [ onClick Reset ] [ text "Reset" ]
        , dataSection model.data
        ]


dataSection : Maybe (List String) -> Html Msg
dataSection data =
    let
        elements =
            data
                |> Maybe.withDefault []
                |> List.map (\entry -> div [ class "data" ] [ text entry ])
    in
        div [ class "slide-in" ] elements

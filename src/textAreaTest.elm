module Main exposing (..)

import Html exposing (Html, Attribute, div, input, text, textarea)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)


main =
    Html.beginnerProgram { model = model, view = view, update = update }



-- MODEL


type alias Model =
    { content : String
    }


model : Model
model =
    { content = "" }



-- UPDATE


type Msg
    = Change String


update : Msg -> Model -> Model
update msg model =
    case msg of
        Change newContent ->
            { model | content = newContent }



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ childTextArea model.content
        , div [] [ text (String.reverse model.content) ]
        ]


defaultTextArea : String -> Html Msg
defaultTextArea content =
    div []
        [ textarea
            [ id "textArea"
            , onInput Change
            , placeholder "Text to reverse…"
            , defaultValue content
            ]
            []

        -- [ text content ]
        ]


valueTextArea : String -> Html Msg
valueTextArea content =
    div []
        [ textarea
            [ id "textArea"
            , onInput Change
            , placeholder "Text to reverse…"
            , value content
            ]
            []
        ]


childTextArea : String -> Html Msg
childTextArea content =
    div []
        [ textarea
            [ id "textArea"
            , onInput Change
            , placeholder "Text to reverse…"
            ]
            [ text content ]
        ]

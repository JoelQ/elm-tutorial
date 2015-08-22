module Counter where

import Html exposing (..)
import Html.Events exposing (onClick)
import Html.Attributes exposing (style)

type alias Model = Int

type Action = Increment | Decrement

init: Int -> Model
init number = number

update : Action -> Model -> Model
update action model =
  case action of
    Increment -> model + 1
    Decrement -> model - 1

type alias Context =
  { actions : Signal.Address Action
  , remove : Signal.Address ()
  }

view : Signal.Address Action -> Model -> Html
view address model =
  div []
  [ button [ onClick address Decrement ] [ text "-" ]
  , div [ countStyle ] [ model |> toString |> text ]
  , button [ onClick address Increment ] [ text "+" ]
  ]

viewWithRemoveButton : Context -> Model -> Html
viewWithRemoveButton context model =
  div []
  [ button [ onClick context.actions Decrement ] [ text "-" ]
  , div [ countStyle ] [ model |> toString |> text ]
  , button [ onClick context.actions Increment ] [ text "+" ]
  , button [ onClick context.remove () ] [ text "X" ]
  ]

countStyle : Attribute
countStyle =
  style
  [ ("font-size", "20px")
  , ("font-family", "monospace")
  , ("display", "inline-block")
  , ("width", "50%")
  , ("text-align", "center")
  ]


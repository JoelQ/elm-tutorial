module CounterPair where

import Counter
import Html exposing (..)
import Html.Attributes exposing (style)
import Html.Events exposing (onClick)

type alias Model =
  {
    topCounter : Counter.Model
  , bottomCounter : Counter.Model
  }

init: Int -> Int -> Model
init top bottom =
  {
    topCounter = Counter.init top
  , bottomCounter = Counter.init bottom
  }

type Action
  = Reset
  | Top Counter.Action
  | Bottom Counter.Action

update : Action -> Model -> Model
update action model =
  case action of
    Reset -> init 0 0

    Top action ->
      { model | topCounter <- Counter.update action model.topCounter }

    Bottom action ->
      { model | bottomCounter <- Counter.update action model.bottomCounter }

view : Signal.Address Action -> Model -> Html
view address model =
  div []
  [ Counter.view (Signal.forwardTo address Top) model.topCounter
  , Counter.view (Signal.forwardTo address Bottom) model.bottomCounter
  , button [ onClick address Reset ] [ text "Reset" ]
  ]

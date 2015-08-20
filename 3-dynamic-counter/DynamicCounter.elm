module DynamicCounter where

import Counter
import Html exposing (..)
import Html.Attributes exposing (style)
import Html.Events exposing (onClick)

type alias Model =
  { counters : List ( ID, Counter.Model )
  , nextId : ID
  }

type alias ID = Int

init : Model
init =
  { counters = []
  , nextId = 0
  }

type Action =
  Insert
  | Remove
  | Modify ID Counter.Action

update : Action -> Model -> Model
update action model =
  case action of
    Insert ->
      let newCounter = ( model.nextId, Counter.init 0 )
          newCounters = model.counters ++ [ newCounter ]
      in
          { model |
            counters <- newCounters,
            nextId <- model.nextId + 1
          }

    Remove ->
      { model | counters <- List.drop 1 model.counters }

    Modify id counterAction ->
      let updateCounter (counterId, counterModel) =
            if counterId == id
               then (counterId, Counter.update counterAction counterModel)
               else (counterId, counterModel)
      in
         { model | counters <- List.map updateCounter model.counters }

view : Signal.Address Action -> Model -> Html
view address model =
  let counters = List.map (viewCounter address) model.counters
      remove = button [ onClick address Remove ] [ text "Remove" ]
      add = button [ onClick address Insert ] [ text "Add" ]
  in
     div [] ([ remove, add ] ++ counters)

viewCounter : Signal.Address Action -> (ID, Counter.Model) -> Html
viewCounter address (id, model) =
  Counter.view (Signal.forwardTo address (Modify id)) model

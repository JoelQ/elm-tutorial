module DynamicCounter where

import Counter
import Html exposing (..)
import Html.Events exposing (onClick)

type alias Model =
  { counters : List (ID, Counter.Model)
  , nextId : ID
  }

type alias ID = Int

init : Model
init =
  { counters = []
  , nextId = 0
  }

type Action
 = Insert
 | Remove ID
 | Modify ID Counter.Action

update : Action -> Model -> Model
update action model =
  case action of
    Insert ->
      { model |
        counters <- ( model.nextId, Counter.init 0 ) :: model.counters,
        nextId <- model.nextId + 1
      }

    Remove id ->
      let remainingCounters =
        List.filter (\(counterId, _) -> counterId /= id)
      in
        { model | counters <- (remainingCounters model.counters) }

    Modify id counterAction ->
      let updateCounter (counterId, counterModel) =
        if counterId == id
           then ( counterId, Counter.update counterAction counterModel)
           else ( counterId, counterModel )
      in
        { model | counters <- List.map updateCounter model.counters }

view : Signal.Address Action -> Model -> Html
view address model =
  let counters = List.map (viewCounter address) model.counters
      add = button [ onClick address Insert ] [ text "Add" ]
  in
    div [] (add :: counters)

viewCounter : Signal.Address Action -> (ID, Counter.Model) -> Html
viewCounter address (id, model) =
  let context =
    { actions = (Signal.forwardTo address (Modify id))
    , remove = (Signal.forwardTo address (always (Remove id)))
    }
  in
    Counter.viewWithRemoveButton context model

module Main where

import DynamicCounter
import StartApp.Simple

main =
  StartApp.Simple.start
  { model = DynamicCounter.init
  , update = DynamicCounter.update
  , view = DynamicCounter.view
  }

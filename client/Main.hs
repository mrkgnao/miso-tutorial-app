module Main where

import           Miso

import           Shared.Action
import           Shared.Model
import           Client.Update
import           Shared.View

main :: IO ()
main = do
    miso $ \uri -> App {
          initialAction = initAction
        , model = initialModel uri
        , update = updateModel
        , view = viewModel
        , subs = [ uriSub HandleURI ]
        , events = defaultEvents
        , mountPoint = Nothing
        }

{-# LANGUAGE DataKinds     #-}
{-# LANGUAGE TypeOperators #-}
module Shared.Routing where

import           Data.Proxy
import           Miso
import           Servant.API
import           Servant.Links

import           Shared.Action
import           Shared.Model

type Route =
         TopRoute
    :<|> ListRoute
    :<|> EditRoute

type TopRoute = View Action

type ListRoute = "players" :> View Action

type EditRoute = "players" :> Capture "ident" PlayerId :> View Action

listLink :: URI
listLink = linkURI $ safeLink (Proxy :: Proxy Route) (Proxy :: Proxy ListRoute)

editLink :: PlayerId -> URI
editLink i = linkURI $ safeLink (Proxy :: Proxy Route) (Proxy :: Proxy EditRoute) i

{-# LANGUAGE DataKinds         #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TypeOperators     #-}
module Server.Api where

import           Miso
import           Servant

import           Shared.Action
import           Shared.Model
import           Shared.Routing
import           Server.Html

type Api = JsonApi :<|> SsrApi :<|> StaticApi :<|> NotFoundApi

type JsonApi =
         "api" :> "players" :> Get '[JSON] [Player]
    :<|> "api" :> "players" :> Capture "id" PlayerId
            :> ReqBody '[JSON] Player :> Put '[JSON] NoContent

type SsrApi = ToServerRoutes Route HtmlPage Action

type StaticApi = "static" :> Raw

type NotFoundApi = Raw

api :: Proxy Api
api = Proxy

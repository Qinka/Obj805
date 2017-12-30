{-
This file is part of obj805-server.

Obj805-server is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

Obj805-server is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with obj805-server.  If not, see <http://www.gnu.org/licenses/>.
-}
{-
Module: Obj805.Handler
Description: The handlers of core.
Copyright: (C) 2018 Johann Lee <me@qinka.pro>
License: GPL3
Maintainer: me@qinka.pro
Stability: experimental
Portablility: unknown

The handlers of core.
-}

{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RecordWildCards #-}

module Obj805.Handler
       ( postSpeedR
       , getSpeedR
       , getHomeR
       ) where


import Obj805.Core
import Import
import Import.STM
import Import.Yesod
import qualified Import.Text as T

postSpeedR :: Handler TypedContent
postSpeedR = do
  speed <- lookupPostParam "speed"
  case speed of
    Just s' -> do
      Core{..} <- getYesod
      let s = read $ T.unpack s'
      liftIO . atomically $ do
        writeTVar  speedReg  s
        writeTChan speedChan s
      selectRep $ provideJson $
        object [ "status" .= ("success" :: String)
               ]
    _ -> selectRep $ provideJson $
      object [ "status"  .= ("error" :: String)
             , "context" .= ("can not find arg(speed)" :: String)
             ]
getSpeedR :: Handler TypedContent
getSpeedR = do
  Core{..} <- getYesod
  webSockets sendInfo
  val <- liftIO $ readTVarIO speedReg
  selectRep $ provideJson $
    object [ "status"  .= ("success" :: String)
           , "content" .= show val
           ]
  where sendInfo = do
          Core{..} <- getYesod
          myChan <- liftIO $ atomically $ dupTChan speedChan
          (liftIO $ readTVarIO speedReg) >>= (sendTextData . T.pack . show)
          forever $ do
            x <- liftIO $ atomically $ readTChan myChan
            sendTextData $ T.pack $ show x

getHomeR :: Handler T.Text
getHomeR = return "Obj805"

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
{-# LANGUAGE TemplateHaskell #-}

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
import qualified Import.ByteString as B
import Control.Concurrent

postSpeedR :: Handler TypedContent
postSpeedR = do
  speed <- lookupPostParam "speed"
  case speed of
    Just s' -> do
      Core{..} <- getYesod
      case T.readMay s' of
        Just s -> do
          liftIO . atomically $ do
            writeTVar  speedReg  s
            writeTChan speedChan s
          selectRep $ provideJson $
            object [ "status" .= ("success" :: String)
                   ] 
        _ -> invalidArgs ["Can not parse arg(speed)",s']
    _ -> invalidArgs ["can not find arg(speed)"]
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
          (liftIO $ readTVarIO speedReg) >>= (sendTextData . T.pack . show)
          myChan <- liftIO $ atomically $ dupTChan speedChan
          let readSpeed    = (liftIO $ atomically $ readTChan myChan)
                >>= sendTextData . T.show
              sleepForPing = (liftIO $ threadDelay 10000000) >> 
                ((liftIO $ readTVarIO speedReg) >>= sendPing . T.show) 
          forever $ race_ readSpeed sleepForPing

getHomeR :: Handler T.Text
getHomeR = return "Obj805"

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
Module: Obj805.Core
Description: The core module for type of this server with Yesod
Copyright: (C) 2018 Johann Lee <me@qinka.pro>
License: GPL3
Maintainer: me@qinka.pro
Stability: experimental
Portablility: unknown

The define the primary items of the backend.
-}

{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TypeFamilies #-}

module Obj805.Core
  ( Core(..)
  , Handler(..)
  , Route(..)
  , resourcesCore
  ) where

import Import
import Import.STM
import Import.Yesod
import qualified Import.Text as T

-- | Basic Types
data Core = Core
  { speedChan :: TChan Double
  , speedReg  :: TVar  Double
  } deriving (Eq)

mkYesodData "Core" [parseRoutes| /      HomeR  GET
                                 /speed SpeedR GET POST|]

instance Yesod Core where
  errorHandler e = selectRep $ provideJson $
    object [ "status"  .= ("error" :: String)
           , "context" .= show e
          ] 

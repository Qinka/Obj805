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
Module: Main
Description: main module for program.
Copyright: (C) 2018 Johann Lee <me@qinka.pro>
License: GPL3
Maintainer: me@qinka.pro
Stability: experimental
Portablility: unknown

Main module for program.
-}


module Main where

import System.Environment
import Import
import Import.STM
import Import.Yesod
import Obj805

main :: IO ()
main = do
  port:_ <- getArgs
  chan <- newBroadcastTChanIO
  reg  <- newTVarIO 0
  warp (read port) (Core chan reg)

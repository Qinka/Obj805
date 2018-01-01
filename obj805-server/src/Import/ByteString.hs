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
Module: Import.ByteString
Description: To import modules
Copyright: (C) 2018 Johann Lee <me@qinka.pro>
License: GPL3
Maintainer: me@qinka.pro
Stability: experimental
Portablility: unknown

To import the bytestring's modules used by program.
-}
module Import.ByteString
  ( module Data.ByteString
  , pack
  , unpack
  , read
  , show
  ) where

import Prelude hiding (read,show)
import qualified Prelude as P

import Data.ByteString hiding (pack,unpack)
import Data.ByteString.Char8 (pack,unpack)

read :: Read a => ByteString -> a
read = P.read . unpack
show :: Show a => a -> ByteString
show = pack . P.show

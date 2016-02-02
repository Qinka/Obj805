




-- Main.hs

{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes       #-}
{-# LANGUAGE TemplateHaskell   #-}
{-# LANGUAGE TypeFamilies      #-}
{-# LANGUAGE ViewPatterns      #-}

module Main
    ( main
    ) where

      import Yesod
      import Control.Concurrent.STM
      import Data.Text

      data Obj = Obj
        { dc :: TVar Int
        }

      instance Yesod Obj

      mkYesod "Obj" [parseRoutes|
      / HomeR GET
      /get-dc DcR GET
      /set/#Int SetR GET
      |]

      getHomeR :: Handler Html
      getHomeR = defaultLayout [whamlet|???|]

      getDcR :: Handler Text
      getDcR = do
        (Obj d) <- getYesod
        liftIO $ fmap (pack.show) $ readTVarIO d

      getSetR :: Int -> Handler Html
      getSetR i = do
        (Obj d) <- getYesod
        liftIO $ atomically $ writeTVar d i
        return "Changed"

      main :: IO ()
      main = do
        x <- newTVarIO 0
        warp 3000 $ Obj x

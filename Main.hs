




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

      instance Yesod Obj where
        defaultLayout w = do
          pc <- widgetToPageContent w
          withUrlRenderer [hamlet|
            $newline never
            $doctype 5
            <html>
              <head>
                #{pageTitle pc}
                <meta charset=utf-8>
                <meta name=viewport content=width=device-width,initial-scale=1.0,maximum-scale=1.0,user-scalable=no>
                ^{pageHead pc}
              <body>
                ^{pageBody pc}
            |]

      mkYesod "Obj" [parseRoutes|
      / HomeR GET
      /get DcR GET
      /set SetR GET
      |]

      getHomeR :: Handler Html
      getHomeR = do
        (Obj d) <- getYesod
        speed <- lookupGetParams "speed"
        case speed of
          s:_ -> do
            let i = read $ read $ show s
            liftIO $ atomically $ writeTVar d i
            return ()
          _-> return ()
        defaultLayout[whamlet|
          当前速度：
          <iframe src=get frameborder=0 height=25>
          <form name=input action="" method=get>
            速度
            <br>
            0
            <input type=radio name=speed value=0>
            <br>
            25
            <input type=radio name=speed value=25>
            <br>
            50
            <input type=radio name=speed value=50>
            <br>
            75
            <input type=radio name=speed value=75>
            <br>
            100
            <input type=radio name=speed value=100>
            <br>
            <input type=submit value=更新 />
          |]

      getDcR :: Handler Text
      getDcR = do
        (Obj d) <- getYesod
        liftIO $ fmap (pack.show) $ readTVarIO d

      getSetR :: Handler Html
      getSetR  = do
        (Obj d) <- getYesod
        speed <- lookupGetParams "speed"
        case speed of
          s:_ -> do
            let i = read $ read $ show s
            liftIO $ atomically $ writeTVar d i
            return "Changed"
          _ -> return "UnChanged"

      main :: IO ()
      main = do
        x <- newTVarIO 0
        warp 3000 $ Obj x

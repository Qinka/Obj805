
\begin{code}
module Obj805.Server.Handler
       ( postSetR
       , getGetR
       ) where
\end{code}


import
\begin{code}
import Import
import Import.Yesod
import qualified Import.Text as T


import Obj805.Server.Core
\end{code}


for setting
\begin{code}
postSetR :: Handler TypedContent
postSetR = do
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
getGetR :: Handler TypedContent
getGetR = do
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
\end{code}

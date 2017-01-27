
\begin{code}
module Obj805.Server.Core
       ( Core(..)
       , Handler(..)
       , Route(..)
       , resourcesCore
       ) where
\end{code}


import
\begin{code}
import Import
import Import.Yesod
import qualified Import.Text as T
\end{code}


basic data
\begin{code}
data Core = Core
            { speedChan :: TChan Int
            , speedReg  :: TVar  Int
            } deriving (Eq)
\end{code}

route
\begin{code}
mkYesodData "Core" [parseRoutes| /get   GetR  GET
                                 /set   SetR  POST
                                 |]
\end{code}

instance Yesod
\begin{code}
instance Yesod Core where
  errorHandler e = selectRep $ provideJson $
    object [ "status"  .= ("error" :: String)
           , "context" .= show e
           ]
\end{code}



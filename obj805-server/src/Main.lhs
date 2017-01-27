

\begin{code}
module Main where
\end{code}

\begin{code}
import Import
import Import.Yesod
import Obj805.Server
\end{code}


\begin{code}
main :: IO ()
main = do
  chan <- newBroadcastTChanIO
  reg  <- newTVarIO 0
  warp 3000 (Core chan reg)
\end{code}



\begin{code}
module Obj805.Server
       ( module X
       ) where
\end{code}


import the modules
\begin{code}
import Import
import Import.Yesod
\end{code}


export
\begin{code}
import Obj805.Server.Core as X
import Obj805.Server.Handler as X
mkYesodDispatch "Core" resourcesCore
\end{code}



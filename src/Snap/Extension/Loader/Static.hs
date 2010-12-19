{-# LANGUAGE TemplateHaskell #-}
-- | This module is a source-compatible replacement for
-- "Snap.Loader.Hint".  It does not import the GHC api, directly or
-- transitively, resulting in a greatly decreased binary size, as
-- compared to the Hint loader.
--
-- This module results in the same code as using the actions in the
-- obvious, straight-forward manner.  It is present *only* as a
-- source-level replacement for the Hint loader, to enable quickly
-- switching the Hint loader off with only a changed import.
module Snap.Extension.Loader.Static where

import           Language.Haskell.TH

import Snap.Extension

------------------------------------------------------------------------------
-- | This function is a shim for source compatibility with loadSnapTH
-- in "Snap.Loader.Hint".  This function is a TH wrapper around a
-- hypothetical function:
--
-- > loadSnap :: IO a -> (a -> IO ()) -> (a -> Snap ()) -> IO (IO (), Snap ())
-- > loadSnap initialize cleanup action = do
-- >     i <- initialize
-- >     return (cleanup i, action i)

-- FIXME: change docs to match two arguments. In particular "initializer" is
-- now an "Initializer s" and "action" is a "SnapExtend s ()"
loadSnapTH :: Name -> Name -> Q Exp
loadSnapTH initializer action = do
    let [initE, actE] = map varE [initializer, action]
    -- FIXME: rename runInitializerHint2
    [| return (runInitializerHint $initE $actE) |]
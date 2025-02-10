{-# LANGUAGE DataKinds #-}
{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE DerivingVia #-}

module Data.PitchClass.Diatonic where

import Data.Act (Act (..), Finitely (..), Torsor (..))
import Data.Finitary (Finitary)
import Data.Finite (Finite)
import Data.Monoid (Sum (..))
import GHC.Generics (Generic)

data PitchClass
  = C
  | D
  | E
  | F
  | G
  | A
  | B
  deriving stock (Bounded, Enum, Eq, Ord, Show, Generic)
  deriving anyclass (Finitary)
  deriving
    (Act (Sum (Finite 7)), Torsor (Sum (Finite 7)))
    via Finitely PitchClass

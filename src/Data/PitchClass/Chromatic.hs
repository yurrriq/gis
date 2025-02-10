{-# LANGUAGE DataKinds #-}
{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE DerivingVia #-}

module Data.PitchClass.Chromatic where

import Data.Act (Act (..), Finitely (..), Torsor (..))
import Data.Finitary (Finitary)
import Data.Finite (Finite)
import Data.Monoid (Sum (..))
import GHC.Generics (Generic)

data PitchClass
  = C
  | Cis
  | D
  | Dis
  | E
  | F
  | Fis
  | G
  | Gis
  | A
  | Ais
  | B
  deriving (Bounded, Enum, Eq, Ord, Show, Generic)
  deriving anyclass (Finitary)
  deriving
    (Act (Sum (Finite 12)), Torsor (Sum (Finite 12)))
    via Finitely PitchClass

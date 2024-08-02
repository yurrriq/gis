{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeApplications #-}
{-# LANGUAGE TypeOperators #-}

module Data.PitchClass.Chromatic where

import Data.Isomorphism (Iso (..))
import Data.Modular (toMod, unMod, ℤ, type (/))

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
  deriving (Bounded, Enum, Eq, Ord, Show)

iso_z12 :: Iso (->) PitchClass (ℤ / 12)
iso_z12 = Iso (toMod @12 . fromIntegral . fromEnum) (toEnum . fromInteger . unMod)

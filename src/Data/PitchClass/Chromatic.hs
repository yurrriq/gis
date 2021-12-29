module Data.PitchClass.Chromatic where

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

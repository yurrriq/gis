module Data.PitchClass.Diatonic where

data PitchClass
  = C
  | D
  | E
  | F
  | G
  | A
  | B
  deriving (Bounded, Enum, Eq, Ord, Show)

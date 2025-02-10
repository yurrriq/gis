{-# LANGUAGE DataKinds #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE MultiParamTypeClasses #-}

module Data.Pitch where

import Data.Act (Act (..), Torsor (..))
import Data.Finitary (Finitary)
import Data.Finite (Finite)
import Data.Monoid (Sum (..))
import qualified Data.PitchClass.Chromatic as Chromatic
import qualified Data.PitchClass.Diatonic as Diatonic

type Octave = Sum Int

newtype (Finitary a) => Pitch a = Pitch {getPitch :: (a, Octave)}

instance (Finitary a, Show a) => Show (Pitch a) where
  show (Pitch (pc, oct)) = show pc <> show (getSum oct)

-- | Cyclic group of order 7.
type ℤ₇ = Sum (Finite 7)

instance Act (Sum Int) (Pitch Diatonic.PitchClass) where
  act n pitch@(Pitch (pc, Sum oct))
    | pc == minBound =
        let (q, r) = getSum n `divMod` 7
         in Pitch (act (fromIntegral r :: ℤ₇) minBound, Sum (q + oct))
    | otherwise = act (n <> (Pitch (minBound, 0) --> pitch)) (Pitch (minBound, 0))

instance Torsor (Sum Int) (Pitch Diatonic.PitchClass) where
  from@(Pitch (pc, oct)) --> to@(Pitch (pc', oct'))
    | pc == minBound = (fromEnum pc' +) . (7 *) <$> (oct' - oct)
    | otherwise = (Pitch (minBound, 0) --> from :: Sum Int) --> (Pitch (minBound, 0) --> to :: Sum Int)

-- | Cyclic group of order 12.
type ℤ₁₂ = Sum (Finite 12)

instance Act (Sum Int) (Pitch Chromatic.PitchClass) where
  act n pitch@(Pitch (pc, Sum oct))
    | pc == minBound =
        let (q, r) = getSum n `divMod` 12
         in Pitch (act (fromIntegral r :: ℤ₁₂) minBound, Sum (q + oct))
    | otherwise = act (n <> (Pitch (minBound, 0) --> pitch)) (Pitch (minBound, 0))

instance Torsor (Sum Int) (Pitch Chromatic.PitchClass) where
  from@(Pitch (pc, oct)) --> to@(Pitch (pc', oct'))
    | pc == minBound = (fromEnum pc' +) . (12 *) <$> (oct' - oct)
    | otherwise = (Pitch (minBound, 0) --> from :: Sum Int) --> (Pitch (minBound, 0) --> to :: Sum Int)

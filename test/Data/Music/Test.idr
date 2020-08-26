module Data.Music.Test

import Data.Music

import Specdris.Spec

%access export

Show Ordering where
  show LT = "lower"
  show EQ = "equal"
  show GT = "higher"

pitchOrdSpec : SpecTree
pitchOrdSpec =
  describe "Pitches are ordered correctly" $ do
    it "Chromatic: D0 < C1" $ do
      let compare = compare@{PitchOrd}
      compare (D, 0) (C, 1) === LT
    it "Diatonic:  D0 < C1" $ do
      let compare = compare@{DiatonicPitchOrd}
      compare (D, 0) (C, 1) === LT

runTests : IO ()
runTests = spec pitchOrdSpec

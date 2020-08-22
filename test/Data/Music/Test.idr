module Data.Music.Test

import Data.Music

import Specdris.Spec

%access export

pitchOrdSpec : SpecTree
pitchOrdSpec =
  describe "PitchOrd" $ do
    it "D0 < C1" $ do
      shouldBeTrue $ (<)@{PitchOrd} (D, 0) (C, 1)

runTests : IO ()
runTests = spec pitchOrdSpec

namespace Main
  main : IO ()
  main = runTests

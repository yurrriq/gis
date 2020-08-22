module Data.GIS.Test

import Data.GIS
import Data.Int.Algebra
import Data.Music

import Specdris.Spec

%access export

pcSpaceExamples : SpecTree
pcSpaceExamples =
  describe "pc-space examples" $ do
    it "int(C, B) = 11" $ do
      int@{PCSpaceGIS} C B === 11
    it "int(G, E) = 9" $ do
      int@{PCSpaceGIS} G E === 9

runTests : IO ()
runTests = spec pcSpaceExamples

-- namespace Main
--   main : IO ()
--   main = runTests

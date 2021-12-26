module Data.GIS.Test

import Control.Algebra.NumericImplementations
import Data.GIS
import Data.Int.Algebra
import Data.Music

import Specdris.Spec

%access export

lewin2_1_1 : SpecTree
lewin2_1_1 = let int = int@{DiatonicPitchGIS} in
  describe "Diatonic pitch examples (Lewin, 2.1.1)" $ do
    it "int(C4, C4) = 0" $ do
      int (C, 4) (C, 4) === 0
    it "int(C4, D4) = 1" $ do
      int (C, 4) (D, 4) === 1
    it "int(C4, E4) = 2" $ do
      int (C, 4) (E, 4) === 2
    it "int(C4, C5) = 7" $ do
      int (C, 4) (C, 5) === 7
    it "int(C4, A3) = -2" $ do
      int (C, 4) (A, 3) === -2
    it "int(E4, G4) = 2" $ do
      int (E, 4) (G, 4) === 2
    it "int(C4, G4) = 4" $ do
      int (C, 4) (G, 4) === 4
    it "int(C4, E4) <+> int(E4, G4) = 4" $ do
      (<+>) (int (C, 4) (E, 4)) (int (E, 4) (G, 4)) === int (C, 4) (G, 4)

lewin2_1_2 : SpecTree
lewin2_1_2 = let int = int@{PSpaceGIS} in
  describe "p-space examples (Lewin, 2.1.2)" $ do
    it "int(C4, D4) = 2" $ do
      int (C, 4) (D, 4) === 2
    it "int(C4, G4) = 7" $ do
      int (C, 4) (G, 4) === 7
    it "int(C4, C5) = 12" $ do
      int (C, 4) (C, 5) === 12
    it "int(C4, F3) = -7" $ do
      int (C, 4) (F, 3) === -7
    it "int(C4, F2) = -19" $ do
      int (C, 4) (F, 2) === -19

lewin2_1_3 : SpecTree
lewin2_1_3 = let int = int@{PCSpaceGIS} in
  describe "pc-space examples (Lewin, 2.1.3)" $ do
    it "int(8, 1) = 5" $ do
      int (fromNat 8) (fromNat 1) === MkZn 5
    it "int(E, E) = 0" $ do
      int E E === MkZn 0
    it "int(E, F) = 1" $ do
      int E F === MkZn 1
    it "int(F, E) = 11" $ do
      int F E === MkZn 11

lewin2_1_4 : SpecTree
lewin2_1_4 = let int = int@{DiatonicPitchClassGIS} in
  describe "Diatonic pitch class examples (Lewin, 2.1.4)" $ do
    it "int(D, D) = 0" $ do
      int D D === MkZn 0
    it "int(D, E) = 1" $ do
      int D E === MkZn 1
    it "int(D, C) = 6" $ do
      int D C === MkZn 6

runTests : IO ()
runTests =
  flip for_ spec $
  [ lewin2_1_1
  , lewin2_1_2
  , lewin2_1_3
  , lewin2_1_4
  ]

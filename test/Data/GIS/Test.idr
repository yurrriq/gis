module Data.GIS.Test

import Data.GIS
import Data.Int.Algebra
import Data.Music

import Specdris.Spec

%access export

lewin2_1_1 : SpecTree
lewin2_1_1 =
  describe "Diatonic pitch examples (Lewin, 2.1.1)" $ do
    it "int(C4, C4) = 0" $ do
      int@{DiatonicPitchGIS} (C, 4) (C, 4) === 0
    it "int(C4, D4) = 1" $ do
      int@{DiatonicPitchGIS} (C, 4) (D, 4) === 1
    it "int(C4, E4) = 1" $ do
      int@{DiatonicPitchGIS} (C, 4) (E, 4) === 2
    it "int(C4, C5) = 1" $ do
      int@{DiatonicPitchGIS} (C, 4) (C, 5) === 7
    it "int(C4, A3) = 1" $ do
      int@{DiatonicPitchGIS} (C, 4) (A, 3) === -2
    it "int(E4, G4) = 2" $ do
      int@{DiatonicPitchGIS} (E, 4) (G, 4) === 2
    it "int(C4, G4) = 4" $ do
      int@{DiatonicPitchGIS} (C, 4) (G, 4) === 4
    it "int(C4, E4) <+> int(E4, G4) = 4" $ do
      (<+>)@{PlusZnSemi} (int@{DiatonicPitchGIS} (C, 4) (E, 4))
        (int@{DiatonicPitchGIS} (E, 4) (G, 4)) === 4

lewin2_1_2 : SpecTree
lewin2_1_2 =
  describe "p-space examples (Lewin, 2.1.2)" $ do
    it "int(C4, D4) = 2" $ do
      int@{PSpaceGIS} (C, 4) (D, 4) === 2
    it "int(C4, G4) = 7" $ do
      int@{PSpaceGIS} (C, 4) (G, 4) === 7
    it "int(C4, C5) = 12" $ do
      int@{PSpaceGIS} (C, 4) (C, 5) === 12
    it "int(C4, F3) = -7" $ do
      int@{PSpaceGIS} (C, 4) (F, 3) === -7
    it "int(C4, F2) = -19" $ do
      int@{PSpaceGIS} (C, 4) (F, 2) === -19

lewin2_1_3 : SpecTree
lewin2_1_3 =
  describe "pc-space examples (Lewin, 2.1.3)" $ do
    -- FIXME
    -- it "int(8, 5) = 1" $ do
    --   int@{PCSpaceGIS} 8 5 === 1
    it "int(E, E) = 0" $ do
      int@{PCSpaceGIS} E E === 0
    it "int(E, F) = 1" $ do
      int@{PCSpaceGIS} E F === 1
    it "int(F, E) = 11" $ do
      int@{PCSpaceGIS} F E === 11

lewin2_1_4 : SpecTree
lewin2_1_4 =
  describe "Diatonic pitch class examples (Lewin, 2.1.4)" $ do
    it "int(D, D) = 0" $ do
      int@{DiatonicPitchClassGIS} D D === 0
    it "int(D, E) = 1" $ do
      int@{DiatonicPitchClassGIS} D E === 1
    it "int(D, C) = 6" $ do
      int@{DiatonicPitchClassGIS} D C === 6

runTests : IO ()
runTests =
  flip for_ spec $
  [ lewin2_1_1
  , lewin2_1_2
  , lewin2_1_3
  , lewin2_1_4
  ]

namespace Main
  main : IO ()
  main = runTests

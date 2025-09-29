{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeApplications #-}
{-# LANGUAGE UnicodeSyntax #-}

module Test.GIS where

import Data.GIS (int)
import Data.PitchClass.Chromatic (C₁₂)
import qualified Data.PitchClass.Chromatic as Chromatic
import qualified Data.PitchClass.Diatonic as Diatonic
import Test.Tasty (TestTree, testGroup)
import Test.Tasty.HUnit (testCase, (@?=))

test_lewin_2_1_1 :: TestTree
test_lewin_2_1_1 =
  testGroup
    "Diatonic pitch examples (Lewin, 2.1.1)"
    [ testCase "int(C4, C4) = 0" $
        int Diatonic.C4 Diatonic.C4 @?= 0,
      testCase "int(C4, D4) = 1" $
        int Diatonic.C4 Diatonic.D4 @?= 1,
      testCase "int(C4, E4) = 2" $
        int Diatonic.C4 Diatonic.E4 @?= 2,
      testCase "int(C4, C5) = 7" $
        int Diatonic.C4 Diatonic.C5 @?= 7,
      testCase "int(C4, A3) = -2" $
        int Diatonic.C4 Diatonic.A3 @?= -2,
      testCase "int(E4, G4) = 2" $
        int Diatonic.E4 Diatonic.G4 @?= 2,
      testCase "int(C4, G4) = 4" $
        int Diatonic.C4 Diatonic.G4 @?= 4,
      testCase "int(C4, E4) + int(E4, G4)) = 4" $
        int Diatonic.C4 Diatonic.E4 + int Diatonic.E4 Diatonic.G4 @?= 4
    ]

test_lewin_2_1_2 :: TestTree
test_lewin_2_1_2 =
  testGroup
    "p-space examples (Lewin, 2.1.2)"
    [ testCase "int(C4, D4) = 2" $
        int Chromatic.C4 Chromatic.D4 @?= 2,
      testCase "int(C4, G4) = 7" $
        int Chromatic.C4 Chromatic.G4 @?= 7,
      testCase "int(C4, C5) = 12" $
        int Chromatic.C4 Chromatic.C5 @?= 12,
      testCase "int(C4, F3) = -7" $
        int Chromatic.C4 Chromatic.F3 @?= -7,
      testCase "int(C4, F2) = -19" $
        int Chromatic.C4 Chromatic.F2 @?= -19
    ]

test_lewin_2_1_3 :: TestTree
test_lewin_2_1_3 =
  testGroup
    "pc-space examples (Lewin, 2.1.3)"
    [ testCase "int(8, 1) = 5" $
        int @C₁₂ @Chromatic.PitchClass 8 1 @?= 5,
      testCase "int(E, E) = 0" $
        int Chromatic.E Chromatic.E @?= 0,
      testCase "int(E, F) = 1" $
        int Chromatic.E Chromatic.F @?= 1,
      testCase "int(F, E) = 11" $
        int Chromatic.F Chromatic.E @?= 11
    ]

test_lewin_2_1_4 :: TestTree
test_lewin_2_1_4 =
  testGroup
    "Diatonic pitch class examples (Lewin, 2.1.4)"
    [ testCase "int(D, D) = 0" $
        int Diatonic.D Diatonic.D @?= 0,
      testCase "int(D, E) = 0" $
        int Diatonic.D Diatonic.E @?= 1,
      testCase "int(D, C) = 6" $
        int Diatonic.D Diatonic.C @?= 6
    ]

-- test_lewin_2_1_5 :: TestTree
-- test_lewin_2_1_5 = undefined

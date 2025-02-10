{-# LANGUAGE TypeApplications #-}
{-# LANGUAGE UnicodeSyntax #-}

module Test.GIS where

import Data.Act (Act (act))
import Data.GIS (GIS (int, ref), ℤ₁₂)
import Data.Pitch (Pitch (..))
import qualified Data.PitchClass.Chromatic as Chromatic
import qualified Data.PitchClass.Diatonic as Diatonic
import Test.Tasty (TestTree, testGroup)
import Test.Tasty.HUnit (testCase, (@?=))

test_lewin_2_1_1 :: TestTree
test_lewin_2_1_1 =
  let int' = int @(Pitch Diatonic.PitchClass)
   in testGroup
        "Diatonic pitch examples (Lewin, 2.1.1)"
        [ testCase "int(C4, C4) = 0" $
            int' (Pitch (Diatonic.C, 4)) (Pitch (Diatonic.C, 4)) @?= 0,
          testCase "int(C4, D4) = 1" $
            int' (Pitch (Diatonic.C, 4)) (Pitch (Diatonic.D, 4)) @?= 1,
          testCase "int(C4, E4) = 2" $
            int' (Pitch (Diatonic.C, 4)) (Pitch (Diatonic.E, 4)) @?= 2,
          testCase "int(C4, C5) = 7" $
            int' (Pitch (Diatonic.C, 4)) (Pitch (Diatonic.C, 5)) @?= 7,
          testCase "int(C4, A3) = -2" $
            int' (Pitch (Diatonic.C, 4)) (Pitch (Diatonic.A, 3)) @?= -2,
          testCase "int(E4, G4) = 2" $
            int' (Pitch (Diatonic.E, 4)) (Pitch (Diatonic.G, 4)) @?= 2,
          testCase "int(C4, G4) = 4" $
            int' (Pitch (Diatonic.C, 4)) (Pitch (Diatonic.G, 4)) @?= 4,
          testCase "int(C4, E4) + int(E4, G4)) = 4" $
            int' (Pitch (Diatonic.C, 4)) (Pitch (Diatonic.E, 4))
              <> int' (Pitch (Diatonic.E, 4)) (Pitch (Diatonic.G, 4))
              @?= 4
        ]

test_lewin_2_1_2 :: TestTree
test_lewin_2_1_2 =
  let int' = int @(Pitch Chromatic.PitchClass)
   in testGroup
        "p-space examples (Lewin, 2.1.2)"
        [ testCase "int(C4, D4) = 2" $
            int' (Pitch (Chromatic.C, 4)) (Pitch (Chromatic.D, 4)) @?= 2,
          testCase "int(C4, G4) = 7" $
            int' (Pitch (Chromatic.C, 4)) (Pitch (Chromatic.G, 4)) @?= 7,
          testCase "int(C4, C5) = 12" $
            int' (Pitch (Chromatic.C, 4)) (Pitch (Chromatic.C, 5)) @?= 12,
          testCase "int(C4, F3) = -7" $
            int' (Pitch (Chromatic.C, 4)) (Pitch (Chromatic.F, 3)) @?= -7,
          testCase "int(C4, F2) = -19" $
            int' (Pitch (Chromatic.C, 4)) (Pitch (Chromatic.F, 2)) @?= -19
        ]

test_lewin_2_1_3 :: TestTree
test_lewin_2_1_3 =
  let int' = int @Chromatic.PitchClass
      act' = act @ℤ₁₂
   in testGroup
        "pc-space examples (Lewin, 2.1.3)"
        [ testCase "int(8, 1) = 5" $
            int' (act' 8 ref) (act' 1 ref) @?= 5,
          testCase "int(E, E) = 0" $
            int' Chromatic.E Chromatic.E @?= 0,
          testCase "int(E, F) = 1" $
            int' Chromatic.E Chromatic.F @?= 1,
          testCase "int(F, E) = 11" $
            int' Chromatic.F Chromatic.E @?= 11
        ]

test_lewin_2_1_4 :: TestTree
test_lewin_2_1_4 =
  let int' = int @Diatonic.PitchClass
   in testGroup
        "Diatonic pitch class examples (Lewin, 2.1.4)"
        [ testCase "int(D, D) = 0" $
            int' Diatonic.D Diatonic.D @?= 0,
          testCase "int(D, E) = 0" $
            int' Diatonic.D Diatonic.E @?= 1,
          testCase "int(D, C) = 6" $
            int' Diatonic.D Diatonic.C @?= 6
        ]

-- test_lewin_2_1_5 :: TestTree
-- test_lewin_2_1_5 = undefined

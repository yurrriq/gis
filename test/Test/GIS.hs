{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE RankNTypes #-}
{-# LANGUAGE TypeApplications #-}

module Test.GIS where

import Control.Monad (guard, void)
import Data.Finitary (inhabitants)
import Data.GIS (GIS (int), IntervalOf)
import Data.Pitch (Pitch (..))
import qualified Data.PitchClass.Chromatic as Chromatic
import qualified Data.PitchClass.Diatonic as Diatonic
import Hedgehog (Gen, Property, forAll, property, withDiscards)
import Hedgehog.Classes (LawContext (..), Laws (..), contextualise, heqCtx, lawsCheck)
import qualified Hedgehog.Gen as Gen
import qualified Hedgehog.Range as Range
import Test.Tasty (TestTree, testGroup)
import Test.Tasty.HUnit (testCase, (@?=))

test_gis_laws :: TestTree
test_gis_laws =
  testGroup
    "Verify GIS laws"
    [ testCase "diatonic pitch class" $
        void . lawsCheck $
          gisLaws genDiatonicPitchClass,
      testCase "diatonic pitch" $
        void . lawsCheck $
          gisLaws genDiatonicPitch,
      testCase "chromatic pitch class" $
        void . lawsCheck $
          gisLaws genChromaticPitchClass,
      testCase "chromatic pitch" $
        void . lawsCheck $
          gisLaws genChromaticPitch
    ]

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
        int @Chromatic.PitchClass 8 1 @?= 5,
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

gisLaws :: (Eq a, Eq (IntervalOf a), GIS a, Show a, Show (IntervalOf a)) => Gen a -> Laws
gisLaws gen =
  Laws
    "GIS"
    [ ("Condition A", gisConditionA gen),
      ("Condition B", gisConditionB gen)
    ]

gisConditionA :: forall a. (Eq a, Eq (IntervalOf a), GIS a, Show a, Show (IntervalOf a)) => Gen a -> Property
gisConditionA gen = property $ do
  r <- forAll gen
  s <- forAll gen
  t <- forAll gen
  let lhs = int r s <> int s t
  let rhs = int r t
  let ctx =
        contextualise $
          LawContext
            { lawContextLawName = "Condition A",
              lawContextTcName = "GIS",
              lawContextLawBody = "int r s <> int s t ≡ int r t",
              lawContextReduced = show lhs ++ " ≡ " ++ show rhs,
              lawContextTcProp =
                let showR = show r; showS = show s; showT = show t
                 in unlines
                      [ "int r s <> int s t ≡ int r t, where",
                        "\tr = " ++ showR,
                        "\ts = " ++ showS,
                        "\tt = " ++ showT
                      ]
            }
  heqCtx lhs rhs ctx

gisConditionB :: forall a. (Eq a, Eq (IntervalOf a), GIS a, Show a, Show (IntervalOf a)) => Gen a -> Property
gisConditionB gen = withDiscards 10000 $ property $ do
  r <- forAll gen
  s <- forAll gen
  t <- forAll gen
  let lhs = int r s
  let rhs = int r t
  guard (lhs == rhs)
  let ctx =
        contextualise $
          LawContext
            { lawContextLawName = "Condition B",
              lawContextTcName = "GIS",
              lawContextLawBody = "int r s ≡ int r t → s ≡ t",
              lawContextReduced = show lhs ++ " ≡ " ++ show rhs,
              lawContextTcProp =
                unlines
                  [ "int r s ≡ int r t ⇔  s ≡ t, where",
                    "\tr = " ++ show r,
                    "\ts = " ++ show s,
                    "\tt = " ++ show t
                  ]
            }
  heqCtx lhs rhs ctx

genChromaticPitchClass :: Gen Chromatic.PitchClass
genChromaticPitchClass = Gen.element inhabitants

genDiatonicPitchClass :: Gen Diatonic.PitchClass
genDiatonicPitchClass = Gen.element inhabitants

genChromaticPitch :: Gen (Pitch Chromatic.PitchClass)
genChromaticPitch = do
  pc <- genChromaticPitchClass
  oct <- Gen.int (Range.linear 0 10)
  pure (Pitch (pc, oct))

genDiatonicPitch :: Gen (Pitch Diatonic.PitchClass)
genDiatonicPitch = do
  pc <- genDiatonicPitchClass
  oct <- Gen.int (Range.linear 0 10)
  pure (Pitch (pc, oct))

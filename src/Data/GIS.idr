module Data.GIS

import Control.Algebra
import Control.Algebra.NumericImplementations
import Data.Int.Algebra
import Data.Music

%access public export

interface Group ivls => HasLabel space ivls where
  LABEL : space -> ivls

interface HasLabel space ivls => GIS space ivls where
  int : space -> space -> ivls
  int s t = LABEL t <-> LABEL s
  conditionA : int r s <+> int s t = int r t
  conditionB : int s t = int s' t' -> (s = s', t = t')


[DiatonicPitchLABEL] HasLabel Diatonic.Pitch Int using PlusZnGroup, DiatonicPitchClassRefC where
  LABEL (pitchClass, octave) = fromNat (toNat pitchClass) + 7 * octave

[DiatonicPitchGIS] GIS Diatonic.Pitch Int using DiatonicPitchLABEL where
  conditionA = believe_me "int r s + int s t = int r t"
  conditionB = believe_me "int s t = int s' t' -> (s = s', t = t')"


[PSpaceLABEL] HasLabel Chromatic.Pitch Int using PlusZnGroup, PitchClassRefC where
  LABEL (pitchClass, octave) = fromNat (toNat pitchClass) + 12 * octave

[PSpaceGIS] GIS Chromatic.Pitch Int using PSpaceLABEL where
  conditionA = believe_me "int r s + int s t = int r t"
  conditionB = believe_me "int s t = int s' t' -> (s = s', t = t')"


[PCSpaceLABEL] HasLabel Chromatic.PitchClass (Zn 12) using PlusZnGroup, PitchClassRefC where
  LABEL = MkZn . fromNat . toNat

[PCSpaceGIS] GIS Chromatic.PitchClass (Zn 12) using PCSpaceLABEL where
  conditionA = believe_me "int r s + int s t = int r t"
  conditionB = believe_me "int s t = int s' t' -> (s = s', t = t')"


[DiatonicPitchClassLABEL] HasLabel Diatonic.PitchClass (Zn 7) using PlusZnGroup, DiatonicPitchClassRefC where
  LABEL = MkZn . fromNat . toNat

[DiatonicPitchClassGIS] GIS Diatonic.PitchClass (Zn 7) using DiatonicPitchClassLABEL where
  conditionA = believe_me "int r s + int s t = int r t"
  conditionB = believe_me "int s t = int s' t' -> (s = s', t = t')"

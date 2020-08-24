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

%access export

[DiatonicPitchClassLABEL] HasLabel Diatonic.PitchClass (Zn 7) using PlusZnGroup where
  LABEL = MkZn . cast

[DiatonicPitchClassGIS] GIS Diatonic.PitchClass (Zn 7) using DiatonicPitchClassLABEL where
  conditionA = believe_me "int r s + int s t = int r t"
  conditionB = believe_me "int s t = int s' t' -> (s = s', t = t')"

[DiatonicPitchLABEL] HasLabel Diatonic.Pitch (Zn 7) using PlusZnGroup where
  LABEL (pitchClass, octave) = MkZn $ cast pitchClass + 7 * octave

[DiatonicPitchGIS] GIS Diatonic.Pitch (Zn 7) using DiatonicPitchLABEL where
  conditionA = believe_me "int r s + int s t = int r t"
  conditionB = believe_me "int s t = int s' t' -> (s = s', t = t')"

[PSpaceLABEL] HasLabel Music.Pitch Int using PlusZnGroup where
  LABEL (pitchClass, octave) = cast pitchClass + 12 * octave

[PSpaceGIS] GIS Music.Pitch Int using PSpaceLABEL where
  conditionA = believe_me "int r s + int s t = int r t"
  conditionB = believe_me "int s t = int s' t' -> (s = s', t = t')"

[PCSpaceLABEL] HasLabel Music.PitchClass (Zn 12) using PlusZnGroup where
  LABEL = MkZn . cast

[PCSpaceGIS] GIS Music.PitchClass (Zn 12) using PCSpaceLABEL where
  conditionA = believe_me "int r s + int s t = int r t"
  conditionB = believe_me "int s t = int s' t' -> (s = s', t = t')"

module Data.GIS

import Control.Algebra
import Control.Algebra.NumericImplementations
import Data.Int.Algebra
import Data.Music

%access public export
%default partial

interface Group ivls => HasLabel s ivls where
  LABEL : s -> ivls

interface HasLabel space ivls => GIS space ivls where
  int : space -> space -> ivls
  int s t = LABEL t <-> LABEL s
  conditionA : int r s <+> int s t = int r t
  conditionB : int s t = int s' t' -> (s = s', t = t')

%access export

[PSpaceLABEL] HasLabel Pitch Int using PlusZnGroup where
  LABEL (pitchClass, octave) = cast pitchClass + 12 * octave

[PpaceGIS] GIS Pitch Int using PSpaceLABEL where
  conditionA = believe_me "int r s + int s t = int r t"
  conditionB = believe_me "int s t = int s' t' -> (s = s', t = t')"

[PCSpaceLABEL] HasLabel PitchClass (Zn 12) using PlusZnGroup where
  LABEL = MkZn . cast

[PCSpaceGIS] GIS PitchClass (Zn 12) using PCSpaceLABEL where
  conditionA = believe_me "int r s + int s t = int r t"
  conditionB = believe_me "int s t = int s' t' -> (s = s', t = t')"

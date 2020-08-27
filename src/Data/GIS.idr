module Data.GIS

import Control.Algebra
import Control.Algebra.NumericImplementations
import Data.Int.Algebra
import Data.Music

%access public export


interface Group ivls => GIS space ivls | space where
  ref     : space
  int     : space -> space -> ivls
  LABEL   : space -> ivls

  int s t = LABEL t <-> LABEL s
  -- LABEL s = if s == ref then neutral else int ref s


[IntScalarGIS] GIS Int Int where
  ref   = 0
  LABEL = id


[DiatonicPitchGIS] GIS Diatonic.Pitch Int where
  ref   = (C, 0)
  LABEL = cast


[PSpaceGIS] GIS Chromatic.Pitch Int where
  ref   = (C, 0)
  LABEL = cast


[PCSpaceGIS] GIS Chromatic.PitchClass (Zn 12) where
  ref   = C
  LABEL = cast


[DiatonicPitchClassGIS] GIS Diatonic.PitchClass (Zn 7) where
  ref   = C
  LABEL = cast


[PitchClassRefFGIS] GIS Chromatic.PitchClass (Zn 12) where
  ref     = F
  LABEL s = MkZn (cast s) <-> MkZn 5

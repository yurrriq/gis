module Data.GIS.Verified

import Control.Algebra
import Data.GIS

%access public export


interface GIS space ivls => VerifiedGIS space ivls | space where
  conditionA : (r, s, t : space) -> int r s <+> int s t = int r t
  conditionB : (s : space) -> (i : ivls) -> (int s t = i, int s t' = i) -> t = t'

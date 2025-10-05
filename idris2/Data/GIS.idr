module Data.GIS

import Algebra.Group
import Data.Fin
import Data.Fin.Extra
import Data.Nat

-- interface (Group ivls) => GIS (space : Type) (ivls : Type) where
--   ref : space
--   int : space -> space -> ivls
--   label : space -> ivls


namespace Diatonic
  public export
  data PitchClass
    = C | D | E | F | G | A | B

assoc : (u, v, w : Fin 7) -> u + (v + w) === (u + v) + w
assoc u v w = homoPointwiseIsEqual (plusAssociative u v w)

wip : Monoid (Fin 7) 0 (+)
wip = MkMonoid (assoc _ _ _) ?rightNeutral ?leftNeutral

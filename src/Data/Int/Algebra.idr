module Data.Int.Algebra

import Control.Algebra
import Data.Nat.DivMod

%access public export


--- ||| Return the smallest non-negative representative of the class of a modulo n.
leastPositiveResidue : (Integral ty, Ord ty) => (a : ty) -> (b : ty) -> ty
leastPositiveResidue a n = let r = a `mod` n in if r < 0 then r + n else r


data Zn : Nat -> Type where
  MkZn : (m : Nat) -> {auto ok : LT m (S k)} -> Zn (S k)


Semigroup (Zn (S k)) where
  left <+> (MkZn Z) = left
  (MkZn Z) <+> right = right
  (MkZn x) <+> (MkZn y {k=k}) with (divMod (x + y) k)
    (MkZn r) <+> (MkZn {k=k} (q * (S k))) | (MkDivMod q r rLtn) = ?rhs

    -- MkZn $ if z < i then z else z - i


-- Monoid (Zn (S k)) where
--   neutral = MkZn Z

-- Group (Zn (S k)) where
--   inverse (MkZn Z) = MkZn Z
--   inverse (MkZn (S j) {ok}) {k} = let prf = lteSuccLeft ok; z = (-) (S k) (S j) {smaller=prf} in ?rhs -- x(MkZn z) -- MkZn ((S k) - a)


Eq (Zn (S k)) where
  (MkZn x) == (MkZn y) = x == y


DecEq (Zn (S k)) where
  decEq x y =
      case x == y of
        True => Yes primitiveEq
        False => No primitiveNotEq
    where
      primitiveEq : x = y
      primitiveEq = really_believe_me (Refl {x})
      primitiveNotEq : x = y -> Void
      primitiveNotEq prf = believe_me {b = Void} ()


Show (Zn (S k)) where
  show (MkZn a) {k} = show (leastPositiveResidue a (fromNat k))

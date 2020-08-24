module Data.Int.Algebra

import Control.Algebra
import Interfaces.Verified

%access public export

[PlusIntSemi] Semigroup Int where
  x <+> y = x + y

[PlusIntSemiV] VerifiedSemigroup Int using PlusIntSemi where
  semigroupOpIsAssociative = believe_me "Int addition is associative"

[PlusIntMonoid] Monoid Int using PlusIntSemi where
  neutral = 0

[PlusIntMonoidV] VerifiedMonoid Int using PlusIntSemiV, PlusIntMonoid where
  monoidNeutralIsNeutralL = believe_me "x + 0 = x"
  monoidNeutralIsNeutralR = believe_me "0 + x = x"

[PlusIntGroup] Group Int using PlusIntMonoid where
  inverse = negate

[PlusIntGroupV] VerifiedGroup Int using PlusIntMonoidV, PlusIntGroup where
  groupInverseIsInverseR = believe_me "x - x = 0"

data Zn : (n : Nat) -> Type where
  MkZn : Int -> Zn n

Eq (Zn n) where
  (MkZn x) == (MkZn y) = x == y

implementation DecEq (Zn n) where
  decEq x y =
      case x == y of
      True => Yes primitiveEq
      False => No primitiveNotEq
    where
      primitiveEq : x = y
      primitiveEq = really_believe_me (Refl {x})
      primitiveNotEq : x = y -> Void
      primitiveNotEq prf = believe_me {b = Void} ()

Show (Zn n) where
  show (MkZn x) = show (x `mod` 12)

-- ||| Return the smallest positive representative of the class of i modulo k.
mod' : (Integral a, Ord a) => (i : a) -> (k : a) -> a
mod' i k = let r = i `mod` k in if r < 0 then r + k else r

Num (Zn n) where
  fromInteger x = MkZn $ fromInteger x `mod'` fromNat n
  (MkZn x) + (MkZn y) = MkZn $ x + y `mod'` fromNat n
  (MkZn x) * (MkZn y) = MkZn $ x * y `mod'` fromNat n

Neg (Zn n) where
  negate (MkZn x) = MkZn $ fromNat n + negate x `mod'` fromNat n
  (MkZn x) - (MkZn y) = MkZn $ x - y `mod'` fromNat n

[PlusZnSemi] Semigroup (Zn n) where
  x <+> y = x + y

[PlusZnMonoid] Monoid (Zn n) using PlusZnSemi where
  neutral = MkZn 0

[PlusZnGroup] Group (Zn n) using PlusZnMonoid where
  inverse = negate

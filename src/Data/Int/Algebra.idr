module Data.Int.Algebra

import Control.Algebra

%access public export


--- ||| Return the smallest non-negative representative of the class of a modulo n.
leastPositiveResidue : (Integral ty, Ord ty) => (a : ty) -> (b : ty) -> ty
leastPositiveResidue a n = let r = a `mod` n in if r < 0 then r + n else r


data Zn : (n : Nat) -> Type where
  MkZn : Int -> Zn n


Semigroup (Zn n) where
  (MkZn x) <+> (MkZn y) = let z = x + y; i = fromNat n in
    MkZn $ if z < i then z else z - i


Monoid (Zn n) where
  neutral = MkZn 0


Group (Zn n) where
  inverse (MkZn x) = MkZn (fromNat n - x)


Eq (Zn n) where
  (MkZn x) == (MkZn y) = x == y


DecEq (Zn n) where
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
  show (MkZn a) = show (leastPositiveResidue a (fromNat n))

module Data.GIS

import Control.Algebra

Semigroup Integer where
  x <+> y = x + y

Monoid Integer where
  neutral = 0

Group Integer where
  inverse = negate

record AdditiveZ where
  constructor GetAdditiveZ
  _ : Integer

Eq AdditiveZ where
  (GetAdditiveZ x) == (GetAdditiveZ y) = x == y

Num AdditiveZ where
  fromInteger = GetAdditiveZ
  (GetAdditiveZ x) + (GetAdditiveZ y) = GetAdditiveZ (x + y)
  (GetAdditiveZ x) * (GetAdditiveZ y) = GetAdditiveZ (x * y)

Neg AdditiveZ where
  negate (GetAdditiveZ x) = GetAdditiveZ (negate x)
  (GetAdditiveZ x) - (GetAdditiveZ y) = GetAdditiveZ (x - y)

Semigroup AdditiveZ where
  (GetAdditiveZ x) <+> (GetAdditiveZ y) = GetAdditiveZ $ x + y

Monoid AdditiveZ where
  neutral = GetAdditiveZ 0

Group AdditiveZ where
  inverse (GetAdditiveZ x) = GetAdditiveZ (negate x)

data Zn : (n : Nat) -> Type where
  MkZn : Integer -> Zn n

Eq (Zn n) where
  (MkZn x) == (MkZn y) = x == y

Num (Zn n) where
  fromInteger x = MkZn $ x `mod` toIntegerNat n
  (MkZn x) + (MkZn y) = MkZn $ (x + y) `mod` toIntegerNat n
  (MkZn x) * (MkZn y) = MkZn $ (x * y) `mod` toIntegerNat n

Neg (Zn n) where
  negate (MkZn x) = MkZn $ negate x `mod` toIntegerNat n
  (MkZn x) - (MkZn y) = MkZn $ (x - y) `mod` toIntegerNat n

data AdditiveZn : (n : Nat) -> Type where
  GetAdditiveZn : Zn n -> AdditiveZn n

Eq (AdditiveZn n) where
  (GetAdditiveZn x) == (GetAdditiveZn y) = x == y

Num (AdditiveZn n) where
  fromInteger = GetAdditiveZn . MkZn
  (GetAdditiveZn x) + (GetAdditiveZn y) = GetAdditiveZn (x + y)
  (GetAdditiveZn x) * (GetAdditiveZn y) = GetAdditiveZn (x * y)

Neg (AdditiveZn n) where
  negate (GetAdditiveZn x) = GetAdditiveZn (negate x)
  (GetAdditiveZn x) - (GetAdditiveZn y) = GetAdditiveZn (x - y)

Semigroup (AdditiveZn n) where
  (GetAdditiveZn (MkZn x)) <+> (GetAdditiveZn (MkZn y)) = GetAdditiveZn (MkZn (x + y))

Monoid (AdditiveZn n) where
  neutral = GetAdditiveZn (MkZn 0)

Group (AdditiveZn n) where
  inverse (GetAdditiveZn (MkZn x)) = GetAdditiveZn (MkZn (negate x))

data GIS : (lift : s -> ivls) -> Type where
  MkGIS :
    Group ivls =>
    (s : Type) ->
    (lift : s -> ivls) ->
    (int : s -> s -> ivls) ->
    GIS lift

mkGIS : Group ivls => (lift : s -> ivls) -> GIS lift
mkGIS {lift} {s} {ivls} = MkGIS s lift int
  where
    int : s -> s -> ivls
    int x y = lift y <+> inverse (lift x)

int : GIS lift {s} {ivls} -> (s -> s -> ivls)
int (MkGIS _ _ int) = int

PSpace : GIS GetAdditiveZ
PSpace = mkGIS GetAdditiveZ

PCSpace : GIS (GetAdditiveZn {n=12})
PCSpace = mkGIS (GetAdditiveZn {n=12})

{-# LANGUAGE DataKinds #-}
{-# LANGUAGE DefaultSignatures #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE UndecidableInstances #-}

module Data.GIS where

import Data.Act (Torsor ((<--)))
import Data.Finitary (Cardinality, Finitary (fromFinite, start, toFinite))
import Data.Group (Group ((~~)))
import Data.Kind (Type)
import GHC.TypeNats (type (<=))

type family IntervalOf (space :: Type) :: Type

class (Group (Interval space)) => GIS space where
  type Interval space :: Type
  type Interval space = IntervalOf space
  ref :: space
  int :: space -> space -> Interval space
  label :: space -> Interval space

  default ref :: (Bounded space) => space
  ref = minBound

  default int :: space -> space -> Interval space
  int s t = label t ~~ label s

  default label :: (Eq space) => space -> Interval space
  label s = if s == ref then mempty else int ref s

  {-# MINIMAL label | int #-}

instance
  {-# OVERLAPPABLE #-}
  ( Interval space ~ IntervalOf space,
    Group (Interval space),
    Finitary space,
    1 <= Cardinality space,
    Torsor (Interval space) space,
    Finitary (Interval space),
    Cardinality space ~ Cardinality (Interval space)
  ) =>
  GIS space
  where
  ref = start
  int s t = t <-- s
  label = fromFinite . toFinite

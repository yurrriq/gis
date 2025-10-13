{-# LANGUAGE DataKinds #-}
{-# LANGUAGE DefaultSignatures #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE UndecidableInstances #-}

-- |
-- Module      : Data.GIS
-- Copyright   : (c) Eric Bailey, 2021-2025
--
-- License     : MIT
-- Maintainer  : eric@ericb.me
-- Stability   : experimental
-- Portability : POSIX
--
-- David Lewin's Generalized Interval Systems ('GIS').
module Data.GIS where

import Data.Act (Torsor ((<--)))
import Data.Finitary (Cardinality, Finitary (fromFinite, toFinite))
import Data.Group (Group ((~~)))
import Data.Kind (Type)

-- | The type of intervals associated with a given musical space in a
-- Generalized Interval System ('GIS').
type family IntervalOf (space :: Type) :: Type

-- | A Generalized Interval System ('GIS') is a triple @(S, (G, ·), 'int')@
-- where
--
--     * \(S\) is a musical space (@space@),
--     * \(G\) is the group of intervals (@Interval space@) for the 'GIS', and
--     * 'int' is a function \(S \times S \to G\)
--       (@space -> space -> Interval space@)
--
-- such that
--
--     (1) \(\forall r,s,t \in S, int(r,s) \cdot int(s,t) = int(r,t)\), and
--     (2) \(\forall s \in S, g \in G, \exists! t \in S, int(s,t) = g\).
class (Group (Interval space)) => GIS space where
  type Interval space :: Type
  type Interval space = IntervalOf space

  -- | A referential element in the musical @space@.
  ref :: space

  -- | The interval between two musical elements.
  int :: space -> space -> Interval space

  -- | Uniquely map a musical element to an element of the group of intervals.
  label :: space -> Interval space

  -- | @'ref' = 'minBound'@
  default ref :: (Bounded space) => space
  ref = minBound

  -- | @'int' s t = 'label' t '~~' 'label' s@
  default int :: space -> space -> Interval space
  int s t = label t ~~ label s

  -- | @'label' = 'int' 'ref'@
  default label :: (Eq space) => space -> Interval space
  label = int ref

  {-# MINIMAL label | int #-}

-- | For a bounded musical space \(S\) (@space@) with the same 'Cardinality' as
-- a 'Group' \(G\) (@'Interval' space@), there exists a 'GIS' @(S, (G, ·),
-- 'int')@ where @'ref' = 0@.
instance
  {-# OVERLAPPABLE #-}
  ( Interval space ~ IntervalOf space,
    Group (Interval space),
    Bounded space,
    Finitary space,
    Torsor (Interval space) space,
    Finitary (Interval space),
    Cardinality space ~ Cardinality (Interval space)
  ) =>
  GIS space
  where
  int s t = t <-- s
  label = fromFinite . toFinite

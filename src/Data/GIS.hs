{-# LANGUAGE ConstraintKinds #-}
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
import Data.Monoid (Sum (..))
import Data.Pitch (Pitch (..), labelPitch)

-- | A Generalized Interval System ('GIS') is a triple @(S, (G, ·), 'int')@
-- where
--
--     * \(S\) is a musical space (@space@),
--     * \(G\) is the group of intervals (@'Interval' space@) for the GIS, and
--     * 'int' is a function \(S \times S \to G\)
--       (@space -> space -> 'Interval' space@)
--
-- such that
--
--     (1) \(\forall r,s,t \in S, int(r,s) \cdot int(s,t) = int(r,t)\), and
--     (2) \(\forall s \in S, g \in G, \exists! t \in S, int(s,t) = g\).
class (Group (Interval space)) => GIS space where
  -- | The group of intervals.
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

-- | The type of intervals associated with a given musical space in a
-- Generalized Interval System ('GIS').
type family IntervalOf (space :: Type) :: Type

-- | A bounded pitch class @space@ with the same 'Cardinality' as a @'Group'
-- ('IntervalOf' space)@.
type PitchClassSpace space =
  ( Bounded space,
    Finitary space,
    Finitary (IntervalOf space),
    Cardinality space ~ Cardinality (IntervalOf space),
    Group (IntervalOf space),
    Torsor (IntervalOf space) space
  )

-- | For a pitch class space \(S\) (@space@) with the same 'Cardinality' as a
-- 'Group' \(G\) (@'IntervalOf' space@), there exists a 'GIS' @(S, (G, ·),
-- 'int')@ where @'ref' = 0@.
instance {-# OVERLAPPABLE #-} (PitchClassSpace space) => GIS space where
  int s t = t <-- s
  label = fromFinite . toFinite

-- | A bounded pitch class @space@ can be used to create a pitch space where
-- intervals are representable in the group of integers under addition.
type PitchSpace space =
  ( Bounded space,
    Finitary space,
    IntervalOf (Pitch space) ~ Sum Int
  )

-- | For a pitch space \(S\) (@'Pitch' space@), where intervals are
-- representable as integers, there exists a 'GIS' @(S, (ℤ, +), 'int')@, where
-- pitches are labeled via 'labelPitch' and @'ref' = 0@.
instance {-# OVERLAPPABLE #-} (PitchSpace space) => GIS (Pitch space) where
  label = labelPitch

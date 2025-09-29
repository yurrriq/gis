{-# LANGUAGE DataKinds #-}
{-# LANGUAGE DefaultSignatures #-}
{-# LANGUAGE FunctionalDependencies #-}
{-# LANGUAGE TypeOperators #-}

module Data.GIS where

import Data.Act (Torsor (..))
import Data.Finitary (Cardinality, Finitary (..), start)
import Data.Group (Group (..)) -- , (~~))
import GHC.TypeNats (type (<=))

class (Group ivls) => GIS ivls space | space -> ivls where
  ref :: space
  int :: space -> space -> ivls
  label :: space -> ivls

  default ref :: (Finitary space, 1 <= Cardinality space) => space
  ref = start

  default int :: (Data.Act.Torsor ivls space) => space -> space -> ivls
  int = (Data.Act.-->)

  default label :: (Finitary space, Finitary ivls, Cardinality space ~ Cardinality ivls) => space -> ivls
  label = fromFinite . toFinite

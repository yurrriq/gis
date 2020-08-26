module Data.Music

import Data.Combinators
import Data.Int.Algebra

%access public export

Octave : Type
Octave = Int

namespace Chromatic
  data PitchClass
    = C
    | Cis
    | D
    | Dis
    | E
    | F
    | Fis
    | G
    | Gis
    | A
    | Ais
    | B

  [PitchClassRefC] Enum PitchClass where
    pred C   = B
    pred Cis = C
    pred D   = Cis
    pred Dis = D
    pred E   = Dis
    pred F   = E
    pred Fis = F
    pred G   = Fis
    pred Gis = G
    pred A   = Gis
    pred Ais = A
    pred B   = Ais

    succ C   = Cis
    succ Cis = D
    succ D   = Dis
    succ Dis = E
    succ E   = F
    succ F   = Fis
    succ Fis = G
    succ G   = Gis
    succ Gis = A
    succ A   = Ais
    succ Ais = B
    succ B   = C

    toNat C   = 0
    toNat Cis = 1
    toNat D   = 2
    toNat Dis = 3
    toNat E   = 4
    toNat F   = 5
    toNat Fis = 6
    toNat G   = 7
    toNat Gis = 8
    toNat A   = 9
    toNat Ais = 10
    toNat B   = 11

    fromNat Z = C
    fromNat (S k) = succ (fromNat k)

  [PitchClassRefCis] Enum PitchClass where
    pred = pred@{PitchClassRefC}
    succ = succ@{PitchClassRefC}
    toNat = Nat.pred . toNat@{PitchClassRefC}
    fromNat = fromNat@{PitchClassRefC} . succ

  [PitchClassRefD] Enum PitchClass where
    pred = pred@{PitchClassRefCis}
    succ = succ@{PitchClassRefCis}
    toNat = Nat.pred . toNat@{PitchClassRefCis}
    fromNat = fromNat@{PitchClassRefCis} . succ

  [PitchClassRefDis] Enum PitchClass where
    pred = pred@{PitchClassRefD}
    succ = succ@{PitchClassRefD}
    toNat = Nat.pred . toNat@{PitchClassRefD}
    fromNat = fromNat@{PitchClassRefD} . succ

  [PitchClassRefE] Enum PitchClass where
    pred = pred@{PitchClassRefDis}
    succ = succ@{PitchClassRefDis}
    toNat = Nat.pred . toNat@{PitchClassRefDis}
    fromNat = fromNat@{PitchClassRefDis} . succ

  [PitchClassRefF] Enum PitchClass where
    pred = pred@{PitchClassRefE}
    succ = succ@{PitchClassRefE}
    toNat = Nat.pred . toNat@{PitchClassRefE}
    fromNat = fromNat@{PitchClassRefE} . succ

  [PitchClassRefFis] Enum PitchClass where
    pred = pred@{PitchClassRefF}
    succ = succ@{PitchClassRefF}
    toNat = Nat.pred . toNat@{PitchClassRefF}
    fromNat = fromNat@{PitchClassRefF} . succ

  [PitchClassRefG] Enum PitchClass where
    pred = pred@{PitchClassRefFis}
    succ = succ@{PitchClassRefFis}
    toNat = Nat.pred . toNat@{PitchClassRefFis}
    fromNat = fromNat@{PitchClassRefFis} . succ

  [PitchClassRefGis] Enum PitchClass where
    pred = pred@{PitchClassRefG}
    succ = succ@{PitchClassRefG}
    toNat = Nat.pred . toNat@{PitchClassRefG}
    fromNat = fromNat@{PitchClassRefG} . succ

  [PitchClassRefA] Enum PitchClass where
    pred = pred@{PitchClassRefGis}
    succ = succ@{PitchClassRefGis}
    toNat = Nat.pred . toNat@{PitchClassRefGis}
    fromNat = fromNat@{PitchClassRefGis} . succ

  [PitchClassRefAis] Enum PitchClass where
    pred = pred@{PitchClassRefA}
    succ = succ@{PitchClassRefA}
    toNat = Nat.pred . toNat@{PitchClassRefA}
    fromNat = fromNat@{PitchClassRefA} . succ

  [PitchClassRefB] Enum PitchClass where
    pred = pred@{PitchClassRefAis}
    succ = succ@{PitchClassRefAis}
    toNat = Nat.pred . toNat@{PitchClassRefAis}
    fromNat = fromNat@{PitchClassRefAis} . succ

  Eq PitchClass using PitchClassRefC where
    (==) = (==) `on` toNat

  Ord PitchClass using PitchClassRefC where
    compare = compare `on` toNat

  Show PitchClass where
    show C   = "C"
    show Cis = "Cis"
    show D   = "D"
    show Dis = "Dis"
    show E   = "E"
    show F   = "F"
    show Fis = "Fis"
    show G   = "G"
    show Gis = "Gis"
    show A   = "A"
    show Ais = "Ais"
    show B   = "B"

  Pitch : Type
  Pitch = Pair PitchClass Octave

  Cast Pitch PitchClass where
    cast = fst

  [PitchOrd] Ord Pitch where
    compare (pc1, oct1) (pc2, oct2) =
      case compare oct1 oct2 of
        EQ => compare pc1 pc2
        res => res

  [PitchShow] Show Pitch where
    show (pc, octave) = show pc ++ show octave


namespace Diatonic
  data PitchClass
    = C
    | D
    | E
    | F
    | G
    | A
    | B

  [DiatonicPitchClassRefC] Enum Diatonic.PitchClass where
    pred C = B
    pred D = C
    pred E = D
    pred F = E
    pred G = F
    pred A = G
    pred B = A

    succ C = D
    succ D = E
    succ E = F
    succ F = G
    succ G = A
    succ A = B
    succ B = C

    toNat C = 0
    toNat D = 1
    toNat E = 2
    toNat F = 3
    toNat G = 4
    toNat A = 5
    toNat B = 6

    fromNat Z     = C
    fromNat (S k) = succ (fromNat k)

  Eq Diatonic.PitchClass using DiatonicPitchClassRefC where
    (==) = (==) `on` toNat

  Ord Diatonic.PitchClass using DiatonicPitchClassRefC where
    compare = compare `on` toNat

  Cast Diatonic.PitchClass Chromatic.PitchClass where
    cast C = C
    cast D = D
    cast E = E
    cast F = F
    cast G = G
    cast A = A
    cast B = B

  Show Diatonic.PitchClass where
    show = show . (cast {to = Chromatic.PitchClass})

  Pitch : Type
  Pitch = Pair Diatonic.PitchClass Octave

  Cast Diatonic.Pitch Diatonic.PitchClass where
    cast = fst

  Cast Diatonic.Pitch Chromatic.Pitch where
    cast (dpc, octave) = (cast dpc, octave)

  [DiatonicPitchOrd] Ord Diatonic.Pitch where
    compare = compare@{PitchOrd} `on` cast

  [DiatonicPitchShow] Show Diatonic.Pitch where
    show = show . cast {to = Chromatic.Pitch}

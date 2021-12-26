module Data.Music

import Data.Combinators
import Data.Int.Algebra


private
divMod : Nat -> Nat -> (Nat, Nat)
divMod n d = (n `div` d, n `mod` d)


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

  Enum PitchClass where
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

  Cast PitchClass Int where
    cast = toIntNat . toNat

  Cast PitchClass (Zn n) where
    cast = MkZn . cast

  Eq PitchClass where
    (==) = (==) `on` toNat

  Ord PitchClass where
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

  Enum Pitch where
    succ (B, oct)  = (C, oct + 1)
    succ (pc, oct) = (succ C, oct)

    pred (C, oct)  = (B, oct - 1)
    pred (pc, oct) = (pred pc, oct)

    toNat (pc, oct) = toNat pc + 12 * (toNat oct)

    fromNat k =
      let (pc, oct) = assert_total (divMod k 12) in
        (fromNat pc, toIntNat oct)

  Cast Pitch PitchClass where
    cast = fst

  Cast Pitch Int where
    cast (pc, oct) = toIntNat (toNat pc) + 12 * oct

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

  Enum Diatonic.PitchClass where
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

  Eq Diatonic.PitchClass where
    (==) = (==) `on` toNat

  Ord Diatonic.PitchClass where
    compare = compare `on` toNat

  Cast Diatonic.PitchClass Int where
    cast = toIntNat . toNat

  Cast Diatonic.PitchClass (Zn n) where
    cast = MkZn . cast

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

  Enum Diatonic.Pitch where
    succ (B, oct)  = (C, oct + 1)
    succ (pc, oct) = (succ C, oct)

    pred (C, oct)  = (B, oct - 1)
    pred (pc, oct) = (pred C, oct)

    toNat (pc, oct) = toNat pc + 7 * (toNat oct)

    fromNat k =
      let (pc, oct) = assert_total (divMod k 7) in
        (fromNat pc, toIntNat oct)

  Cast Diatonic.Pitch Diatonic.PitchClass where
    cast = fst

  Cast Diatonic.Pitch Chromatic.Pitch where
    cast (dpc, octave) = (cast dpc, octave)

  Cast Diatonic.Pitch Int where
    cast (pc, oct) = toIntNat (toNat pc) + 7 * oct

  [DiatonicPitchOrd] Ord Diatonic.Pitch where
    compare = compare@{PitchOrd} `on` cast

  [DiatonicPitchShow] Show Diatonic.Pitch where
    show = show . cast {to = Chromatic.Pitch}

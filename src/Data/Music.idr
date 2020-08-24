module Data.Music

import Data.Combinators

%access public export

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
  pred _   = C

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
  succ _   = B

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

  fromNat Z                                         = C
  fromNat (S Z)                                     = Cis
  fromNat (S (S Z))                                 = D
  fromNat (S (S (S Z)))                             = Dis
  fromNat (S (S (S (S Z))))                         = E
  fromNat (S (S (S (S (S Z)))))                     = F
  fromNat (S (S (S (S (S (S Z))))))                 = Fis
  fromNat (S (S (S (S (S (S (S Z)))))))             = G
  fromNat (S (S (S (S (S (S (S (S Z))))))))         = Gis
  fromNat (S (S (S (S (S (S (S (S (S Z)))))))))     = A
  fromNat (S (S (S (S (S (S (S (S (S (S Z)))))))))) = Ais
  fromNat _                                         = B

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

Eq PitchClass where
  (==) = (==) `on` toNat

Ord PitchClass where
  compare = compare `on` toNat

Cast PitchClass Int where
  cast = fromNat . toNat

isDiatonic : PitchClass -> Bool
isDiatonic Cis = False
isDiatonic Dis = False
isDiatonic Fis = False
isDiatonic Gis = False
isDiatonic Ais = False
isDiatonic _   = True

Octave : Type
Octave = Int

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

  Enum Diatonic.PitchClass where
    pred E = D
    pred F = E
    pred G = F
    pred A = G
    pred B = A
    pred _ = C

    succ C = D
    succ D = E
    succ E = F
    succ F = G
    succ G = A
    succ _ = B

    toNat C = 0
    toNat D = 1
    toNat E = 2
    toNat F = 3
    toNat G = 4
    toNat A = 5
    toNat B = 6

    fromNat Z                     = C
    fromNat (S Z)                 = D
    fromNat (S (S Z))             = E
    fromNat (S (S (S Z)))         = F
    fromNat (S (S (S (S Z))))     = G
    fromNat (S (S (S (S (S Z))))) = A
    fromNat _                     = B

  Eq Diatonic.PitchClass where
    (==) = (==) `on` toNat

  Ord Diatonic.PitchClass where
    compare = compare `on` toNat

  Cast Diatonic.PitchClass Int where
    cast = fromNat . toNat

  Cast Diatonic.PitchClass Music.PitchClass where
    cast C = C
    cast D = D
    cast E = E
    cast F = F
    cast G = G
    cast A = A
    cast B = B

  Show Diatonic.PitchClass where
    show C = "C"
    show D = "D"
    show E = "E"
    show F = "F"
    show G = "G"
    show A = "A"
    show B = "B"

  Pitch : Type
  Pitch = Pair Diatonic.PitchClass Octave

  Cast Diatonic.Pitch Diatonic.PitchClass where
    cast = fst

  Cast Diatonic.Pitch Music.Pitch where
    cast (dpc, octave) = (cast dpc, octave)

  [DiatonicPitchOrd] Ord Diatonic.Pitch where
    compare (pc1, oct1) (pc2, oct2) =
      case compare oct1 oct2 of
        EQ => compare pc1 pc2
        res => res

  [DiatonicPitchShow] Show Diatonic.Pitch where
    show (pc, octave) = show pc ++ show octave

module SMCDEL.Internal.Sanity where

import SMCDEL.Internal.Parse
import SMCDEL.Language

-- | Sanity checks that are used by both the CLI and the Web interface.
sanityCheck :: CheckInput -> [String]
sanityCheck (CheckInput vocabInts lawform obsSpec jobs) =
  let
    agents = map fst obsSpec
    vocab = map P vocabInts
    jobForms = [ f | (TrueQ _ f) <- jobs ] ++ [ f | (ValidQ f) <- jobs ] ++ [ f | (WhereQ f) <- jobs ]
    jobAtoms = concat [ ps | (TrueQ ps _) <- jobs ]
  in
    [ "OBS contains atoms not in VARS!" | not (all (all (`elem` vocabInts) . snd) obsSpec) ]
    ++
    [ "LAW uses atoms not in VARS!" | not $ all (`elem` vocab) (propsInForm lawform) ]
    ++
    [ "Query formula contains atoms not in VARS!" | not $ all (all (`elem` vocab) . propsInForm) jobForms ]
    ++
    [ "Query formula contains agents not in OBS!" | not $ all (all (`elem` agents) . agentsInForm) jobForms ]
    ++
    [ "TRUE? query contains atoms not in VARS!" | not $ all (`elem` vocabInts) jobAtoms ]

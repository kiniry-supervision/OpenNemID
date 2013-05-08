module Crypto

open Protocol
open TypeFunc

type prin = string
type pubkey :: prin => *
type privkey :: prin => *
type dsig
type nonce = string
type cypher

(*Verification*)
type Log :: prin => string => E

type LogAuth :: prin => Authentication => E

val Keygen: p:prin
          -> (pubkey p * privkey p)

val Sign: p:prin
        -> privkey p
        -> msg:string{Log p msg}
        -> dsig

val SignAuth: p:prin
        -> privkey p
        -> msg:Authentication{LogAuth p msg}
        -> dsig

val VerifySignature: p:prin
        -> pubkey p 
        -> msg:string
        -> dsig
        -> b:bool{b=true ==> Log p msg}

val VerifySignatureAuth: p:prin
        -> pubkey p 
        -> msg:Authentication
        -> dsig
        -> b:bool{b=true ==> LogAuth p msg}

val Encrypt: p:prin
        -> pubkey p
        -> string
        -> cypher

val Decrypt: p:prin
        -> privkey p
        -> cypher
        -> string

val GenerateNonce: prin -> nonce (*Add refinement to ensure unqueness*)
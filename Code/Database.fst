module Database

open SamlProtocol
open Crypto
open CertStore
open TypeFunc

(*Identity provider functionality*)
val whitelist: idp:prin -> unit
val blacklist: idp:prin -> unit
val addidp: idp:prin -> unit
val whitelisted: idp:prin -> bool

(*User functionality*)
val adduser: user:string -> password:string -> unit

val addnfactor: user:string -> nfactor:Authentication -> unit
val removenfactor: user:string -> nfactor:Authentication -> unit

val getnfactor: user:string -> Authentication
val checknfactor: user:string -> Authentication -> bool
val allnfactauthed: user:string -> bool
val resetnfact: user:string -> unit

val checklogin: user:string -> password:string -> bool

val revokeidp: user:string -> idp:prin -> unit

val revokedidp: user:string -> idp:prin -> bool

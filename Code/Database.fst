module Database

open SamlProtocol
open Crypto

(*Identity provider functionality*)
val whitelist: idp:prin -> unit
val blacklist: idp:prin -> unit
val addidp: idp:prin -> unit
val whitelisted: idp:prin -> bool

(*User functionality*)
val adduser: user:string -> password:string -> unit
val addcpruser: cpr:int -> password:string -> unit

val addnfactor: user:string -> nfactor:Authentication -> unit
val removenfactor: user:string -> nfactor:Authentication -> unit
val cpraddnfactor: cpr:int -> nfactor:Authentication -> unit
val cprremovenfactor: cpr:int -> nfactor:Authentication -> unit

val getnfactor: user:string -> Authentication
val cprgetnfactor: cpr:int -> Authentication

val checkcprlogin: cpr:int -> password:string -> bool
val checkuserlogin: user:string -> password:string -> bool

val revokeidp: cpr:int -> idp:prin -> unit
val revokeidp: user:string -> idp:prin -> unit

val revokedidp: user:string -> idp:prin -> bool
val cprrevokedidp: cpr:int -> idp:prin -> bool

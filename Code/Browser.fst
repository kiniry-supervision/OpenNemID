module Browser

open SamlProtocol
open Crypto

val loginWithFb: Authentication
val loginWithGoogle: Authentication
val loginWithSMS: Authentication
val loginWithOpenId: Authentication
val fakeprint: str:string -> unit
(*Handle the two-factor authentication*)

val handleAuthMethod: auth:Authentication -> Authentication

let handleAuthMethod auth = 
	match auth with
	| Facebook(fbid) -> loginWithFb
	| Google(gid) -> loginWithGoogle
	| SMS(gen) -> loginWithSMS
	| OpenId(oid) -> loginWithOpenId
					
val loop: user:string -> idp:prin -> sp:prin -> unit

let rec loop user idp sp =
	let loginresp = ReceiveSaml idp in
		match loginresp with
		| UserAuthRequest(authmethod, challenge) ->
			let authtry = handleAuthMethod authmethod in
			let authInfo = UserAuth user authtry in
			let authresp = UserAuthResponse authInfo challenge in
			SendSaml idp authresp;
			loop user idp sp
		| AuthResponseMessage(idenp, dest, assertion) ->
			SendSaml sp loginresp
		| _ -> loginresp; ()

val browser: sp:prin -> res:uri -> user:string -> password:string -> unit

let browser sp resource user password =
	let req = SPLogin resource in
	let _ = SendSaml sp req in
		let res = ReceiveSaml sp in
		match res with
		| AuthnRequestMessage(sp, idp, message, sigSP) ->
			SendSaml idp res;
			let idpResp = ReceiveSaml idp in
			match idpResp with
			| UserCredRequest(challenge) ->
				let loginInfo = UserLogin user password in
				let loginreq = Login loginInfo challenge in
				SendSaml idp loginreq;
				loop user idp sp;
				let spResp = ReceiveSaml sp in
					match spResp with
					| LoginResponse(str) ->
							fakeprint str
					| _ -> spResp; ()
			| _ -> idpResp; ()
		| _ -> res; ()
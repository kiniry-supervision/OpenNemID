module Browser

open SamlProtocol
open Crypto
open CertStore
open TypeFunc

val loginWithFb: Authentication
val loginWithGoogle: Authentication
val loginWithSMS: Authentication
val loginWithOpenId: Authentication
val userid: string
val password: string
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

let rec loop userid idp sp =
	let loginresp = ReceiveSaml idp in
		match loginresp with
		| UserAuthRequest(authmethod, challenge, sigAuth) ->
			let authresponse = handleAuthMethod authmethod in
			let authInfo = UserAuth userid authmethod authresponse in
			let authresp = UserAuthResponse authInfo challenge sigAuth in
			SendSaml idp authresp;
			loop userid idp sp
		| AuthResponseMessage(idenp, dest, assertion) ->
			SendSaml sp loginresp
		| _ -> loginresp; ()

val browser: sp:prin -> res:uri -> unit

let browser sp resource =
	let req = SPLogin resource in
	let _ = SendSaml sp req in
		let res = ReceiveSaml sp in
		match res with
		| AuthnRequestMessage(sp, idp, message, sigSP) ->
			let _ = SendSaml idp res in
			let idpResp = ReceiveSaml idp in
			match idpResp with
			| UserCredRequest(javascript, challenge, sigIdP) ->
				let pubkissuer = CertStore.GetPublicKey idp in
				if VerifySignature idp pubkissuer javascript sigIdP then 
					(assert (Log idp javascript);
					let loginInfo = UserLogin userid password in
					let loginreq = Login loginInfo challenge in
					SendSaml idp loginreq;
					loop userid idp sp;
					let spResp = ReceiveSaml sp in
					match spResp with
					| LoginResponse(str) ->
							fakeprint str
					| _ -> spResp; ())
				else
					fakeprint "Validation Error"
			| _ -> idpResp; ()
		| _ -> res; ()
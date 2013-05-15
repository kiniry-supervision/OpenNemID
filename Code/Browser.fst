module Browser

open SamlProtocol
open Crypto
open CertStore
open TypeFunc
open Messaging

val loginWithFb: Authentication
val loginWithGoogle: Authentication
val loginWithSMS: Authentication
val loginWithOpenId: Authentication
val userid: string
val password: string
val fakeprint: str:string -> unit
val newUserId: string
val newPassword: string
val idpToRevoke:string
val nfactToRemove: Authentication
val nfactToAdd: Authentication
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

val retrieveGeneratedPassword: string

val createUser: authp:prin -> unit

let createUser authp =
	let name = userid in
	let pw = password in
	let req = RequestForLogin name pw in
	let _ = SendMessage authp req in
		let resp = ReceiveMessage authp in
		match resp with
		| ReqLoginResponse(challenge) ->
			let reqlresp = CreateLogin retrieveGeneratedPassword challenge in
			let _ = SendMessage authp reqlresp in
			let createloginresp = ReceiveMessage authp in
			match createloginresp with
			| StatusMessage(status) ->
				match status with
				| Successful -> fakeprint "You have created an account"
				| Unsuccessful -> fakeprint "Something went wrong. No account has been created"
			| _ -> createloginresp; ()
		| _ -> resp; ()

val changeUserPassword: authp:prin -> unit

let changeUserPassword authp =
	let name = userid in
	let pw = password in
	let newpw = newPassword in
	let req = ChangePassword name pw newpw in
	let _ = SendMessage authp req in
		let resp = ReceiveMessage authp in
		match resp with
		| StatusMessage(status) ->
				match status with
				| Successful -> fakeprint "You have change your password"
				| Unsuccessful -> fakeprint "Something went wrong. You have not changed your password"
		| _ -> resp; ()

val changeUserUserId: authp:prin -> unit

let changeUserUserId authp =
	let name = userid in
	let pw = password in
	let newid = newUserId in
	let req = ChangeUserId name newid pw in
	let _ = SendMessage authp req in
	let resp = ReceiveMessage authp in
		match resp with
		| StatusMessage(status) ->
				match status with
				| Successful -> fakeprint "You have change your userid"
				| Unsuccessful -> fakeprint "Something went wrong. You have not changed your userid"
		| _ -> resp; ()

val identityrevoke: authp:prin -> unit

let identityrevoke authp =
	let name = userid in
	let pw = password in
	let idp = idpToRevoke in
	let req = UserRevokeIdp name pw idp in
	let _ = SendMessage authp req in
	let resp = ReceiveMessage authp in
		match resp with
		| StatusMessage(status) ->
				match status with
				| Successful -> fakeprint "You have revoked the identityprovider"
				| Unsuccessful -> fakeprint "Something went wrong. You have not revoked the identityprovider"
		| _ -> resp; ()

val addNfact: authp:prin -> unit

let addNfact authp =
	let name = userid in
	let pw = password in
	let nfact = nfactToAdd in
	let req = AddNfactor name pw nfact in
	let _ = SendMessage authp req in
	let resp = ReceiveMessage authp in
		match resp with
		| StatusMessage(status) ->
				match status with
				| Successful -> fakeprint "You have added this n factor authentication method"
				| Unsuccessful -> fakeprint "Something went wrong. You have not added this n factor authentication method"
		| _ -> resp; ()

val removeNfact: authp:prin -> unit

let removeNfact authp =
	let name = userid in
	let pw = password in
	let nfact = nfactToRemove in
	let req = RemoveNfactor name pw nfact in
	let _ = SendMessage authp req in
	let resp = ReceiveMessage authp in
		match resp with
		| StatusMessage(status) ->
				match status with
				| Successful -> fakeprint "You have removed this n factor authentication method"
				| Unsuccessful -> fakeprint "Something went wrong. You have not removed this n factor authentication method"
		| _ -> resp; ()
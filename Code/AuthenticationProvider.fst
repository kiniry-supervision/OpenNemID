module Authenticationprovider

open SamlProtocol
open Crypto
open Database
open TypeFunc

(*
val createAssertion: me:prin -> user:prin -> Assertion

let createAssertion me user idp =
	let assertion = MakeAssertion me user idp in
	let myprivk = CertStore.GetPrivateKey me in
	assume(Log me assertion);
	let pubkidp = CertStore.GetPublicKey idp in
	let sigAs = Sign me myprivk assertion in
	let signAssertion = AddSignatureToAssertion assertion sigAs in
	EncryptAssertion idp pubkidp signAssertion
*)

val relatechallenge: user:prin -> challenge:nonce -> unit

val verifychallenge: user:prin -> challenge:nonce -> bool

val nfactauth: me:prin -> idp:prin -> user:prin -> userid:string -> unit

let nfactauth me idp user userid =
	if (allnfactauthed userid) then
		resetnfact userid;
		let status = "OK" in
		let resp = LoginSuccess status me idp in
		SendSaml idp resp
	else
		let challenge = GenerateNonce me in
		let authmethod = getnfactor userid in
		assume(LogAuth user authmethod);
		let userprivkey = CertStore.GetPrivateKey user in
		let sigUser = SignAuth user userprivkey authmethod in
		let resp = LoginResponseMessage me idp authmethod challenge sigUser in
		SendSaml idp resp

val authenticationprovider: me:prin -> idp:prin -> user:prin -> unit

let rec authenticationprovider me idp user =
	let req = ReceiveSaml idp in
	match req with
	| LoginRequestMessage (issuer, destination, loginInfo) ->
		if (whitelisted idp) then
			match loginInfo with
			| UserLogin(userid, password) ->
				if not (revokedidp userid idp) && (checklogin userid password) then
					let challenge = GenerateNonce me in
					let authmethod = getnfactor userid in
					assume(LogAuth user authmethod);
					let userprivkey = CertStore.GetPrivateKey user in
					let sigUser = SignAuth user userprivkey authmethod in
					relatechallenge user challenge;
					let resp = LoginResponseMessage me idp authmethod challenge sigUser in
					SendSaml idp resp;
					authenticationprovider me idp user
				else
					SendSaml idp (Failed User);
					authenticationprovider me idp user
			| _ -> SendSaml idp (Failed Requester);
				authenticationprovider me idp user
		else
			SendSaml idp (Failed Requester);
			authenticationprovider me idp user
	| NfactAuthRequest(issuer, destination, authInfo, challenge, sigAuth) ->
		if (whitelisted idp) then
			match authInfo with
			| UserAuth(userid, authmethod, authresponse) ->
				let userpubkey = CertStore.GetPublicKey user in
				if VerifySignatureAuth user userpubkey authmethod sigAuth && verifychallenge user challenge then
					if not (revokedidp userid idp) && (checknfactor userid authresponse) then
						nfactauth me idp user userid;
						authenticationprovider me idp user
					else
						SendSaml idp (Failed User);
						authenticationprovider me idp user
				else
					SendSaml idp (Failed User);
					authenticationprovider me idp user
			| _ -> SendSaml idp (Failed Requester);
				authenticationprovider me idp user
		else
			SendSaml idp (Failed Requester);
			authenticationprovider me idp user
	| _ -> SendSaml idp (Failed Requester);
		authenticationprovider me idp user

val usercommunication: me:prin -> user:prin -> unit

(*
let rec authenticationprovider me user =
	let req = ReceiveSaml idp in
	match req with
	| UserRequest -> do something
	| _ -> SendSaml user (DisplayError 400);
		usercommunication me user*)
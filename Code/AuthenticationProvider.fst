module Authenticationprovider

open SamlProtocol
open Crypto
open Database
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

val nfactauth: me:prin -> idp:prin -> name:string -> assertion:Assertion -> unit

let nfactauth me idp name assertion =
	if (allnfactauthed name) then
		resetnfact name;
		let status = "OK" in
		let resp = LoginSuccess status me idp assertion in
		SendSaml idp resp
	else
		let challenge = GenerateNonce me in
		let authmethod = getnfactor name in
		let resp = LoginResponseMessage me idp assertion authmethod challenge in
		SendSaml idp resp

val authenticationprovider: me:prin -> idp:prin -> user:prin -> unit

let rec authenticationprovider me idp user =
	let req = ReceiveSaml idp in
	match req with
	| LoginRequestMessage (issuer, destination, message, loginInfo, sigIdP) ->
		let pubkissuer = CertStore.GetPublicKey issuer in
		if (whitelisted idp) && (VerifySignature issuer pubkissuer message sigIdP) then
			(assert (Log issuer message);
			match loginInfo with
			| UserLogin(name, password) ->
				if not (revokedidp name idp) && (checklogin name password) then
					(*Find the n-factor auth method - How / which one if more?*)
					let challenge = GenerateNonce me in
					let assertion = MakeAssertion me user idp in
					let myprivk = CertStore.GetPrivateKey me in
					assume(Log me assertion);
					let pubkidp = CertStore.GetPublicKey idp in
					let sigAs = Sign me myprivk assertion in
					let signAssertion = AddSignatureToAssertion assertion sigAs in
					let assertion = EncryptAssertion idp pubkidp signAssertion in
					let authmethod = getnfactor name in
					let resp = LoginResponseMessage me idp assertion authmethod challenge in
					SendSaml idp resp;
					authenticationprovider me idp user
				else
					SendSaml idp (Failed User);
					authenticationprovider me idp user
			| _ -> SendSaml idp (Failed Requester);
				authenticationprovider me idp user
			)
		else
			SendSaml idp (Failed Requester);
			authenticationprovider me idp user
	| NfactAuthRequest(issuer, destination, message, authInfo, challenge, sigIdP)->
		(*Associate the challenge to the challenge generated at the first login*)
		let pubkissuer = CertStore.GetPublicKey issuer in
		if (whitelisted idp) && (VerifySignature issuer pubkissuer message sigIdP) then
			(assert (Log issuer message);
			match authInfo with
			| UserAuth(name, auth) ->
				if not (revokedidp name idp) && (checknfactor name auth) then
					let assertion = MakeAssertion me user idp in
					let myprivk = CertStore.GetPrivateKey me in
					assume(Log me assertion);
					let pubkidp = CertStore.GetPublicKey idp in
					let sigAs = Sign me myprivk assertion in
					let signAssertion = AddSignatureToAssertion assertion sigAs in
					let assertion = EncryptAssertion idp pubkidp signAssertion in
					nfactauth me name idp assertion;
					authenticationprovider me idp user
				else
					SendSaml idp (Failed User);
					authenticationprovider me idp user
			| _ -> SendSaml idp (Failed Requester);
				authenticationprovider me idp user)
		else
			SendSaml idp (Failed Requester);
			authenticationprovider me idp user
	| _ -> SendSaml idp (Failed Requester);
		authenticationprovider me idp user
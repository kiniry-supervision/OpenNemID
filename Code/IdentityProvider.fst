module Identityprovider

open SamlProtocol
open Crypto
(* Must handle a receivesaml from authentication provider that specifies the second
authentication method and then prompt client for it - and handle if the clients
information was correct *)

type SecurityRestriction = 
	| Session: 1
	| User: 2
	| IdP: 4

type SecurityProfile =
	| Profile:	prin -> SecurityRestriction ->
				int -> SecurityProfile

val identityprovider: me:prin -> user:prin -> authp:prin -> unit
val authenticateuser: me:prin -> user:prin -> authp:prin -> unit

let rec identityprovider me user authp =
	let request = ReceiveSaml user in
	match request with
	| Login (loginInfo) ->
		(*let authnReq = CreateAuthnRequestMessage me authp in
		assume(Log me authnReq);
		let meprivk = CertStore.GetPrivateKey me in
		let sigIdP = Sign me meprivk authnReq in
		let response = AuthnRequestMessage me authp authnReq sigIdP in*)
		(*sendsaml to authenticationprovider with logininfo*)
		let authnReq = CreateAuthnRequestMessage me authp in
		assume(Log me authnReq);
		let myprivk = CertStore.GetPrivateKey me in
		let sigIdP = Sign me myprivk authnReq in
		let req = AuthnRequestMessage me authp authnReq loginInfo sigIdP in
		SendSaml authp req;
		identityprovider me user authp
	| 
	| _ -> SendSaml user (DisplayError 400);
		identityprovider me user authp

let rec authenticateuser me user authp =
	let request = ReceiveSaml authp in
	match request with
	| AuthResponseMessage(issuer, destination, encassertion, authmethod) ->
		let meprivk = CertStore.GetPrivateKey me in
		let assertion = DecryptAssertion me meprivk encassertion in
		match assertion with
		| SignedAssertion (token, sigAuthP) ->
			let pubkissuer = CertStore.GetPublicKey authp in
			if VerifySignature authp pubkissuer token sigAuthP
			then
				(assert (Log authp token);
				let response = UserAuthRequest authmethod request in
				SendSaml user response)
			else SendSaml user (DisplayError 403);
			authenticateuser me user authp
	| _ -> SendSaml user (DisplayError 400);
		authenticateuser me user authp
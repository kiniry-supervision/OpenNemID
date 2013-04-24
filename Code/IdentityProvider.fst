module Identityprovider

open SamlProtocol
open Crypto
(* Must handle a receivesaml from authentication provider that specifies the second
authentication method and then prompt client for it - and handle if the clients
information was correct *)
val identityprovider: me:prin -> user:prin -> authp:prin -> unit

let rec identityprovider me user authp =
	let request = ReceiveSaml user in
	match request with
	| Login (url) ->
		let authnReq = CreateAuthnRequestMessage me authp in
		assume(Log me authnReq);
		let meprivk = CertStore.GetPrivateKey me in
		let sigIdP = Sign me meprivk authnReq in
		let response = AuthnRequestMessage me authp authnReq sigIdP in
		SendSaml client response;
		identityprovider me client authp

	| AuthResponseMessage (issuer, destination, encassertion) ->
		let meprivk = CertStore.GetPrivateKey me in
		let assertion = DecryptAssertion me meprivk encassertion in
		match assertion with
		| SignedAssertion (token, sigAuthP) ->
			let issuerpubkey = CertStore.GetPublicKey authp in
			if VerifySignature authp issuerpubkey token sigAuthP
			then 
				(assert (Log authp token);
				let response = LoginResponse "You are now logged in" in
				SendSaml client response)
			else SendSaml client (DisplayError 403);
			identityprovider me user authp
	| _ -> SendSaml client (DisplayError 400);
		identityprovider me user authp
module Authenticationprovider

open SamlProtocol
open Crpyto
(*Must send saml to identity provider about the ways of second
authentication method and what is the correct information.
Perhaps via the client. No contact to the client in this? Only IdP?*)
val authenticationprovider me:prin -> idp:prin -> unit
let authenticationprovider me idp =
	let req = ReceiveSaml idp in
	match req with
	| AuthnRequestMessage (issuer, destination, message, loginInfo, sigIdP) ->
		let pubkissuer = CertStore.GetPublicKey issuer in
		(*Add check for the blacklist / whitelist in db in the if statement before
		verifysignature*)
		if (VerifySignature issuer pubkissuer message sigIdP) then
			(assert (Log issuer message);
			(*Check logindata vs the info stored in db*)
			(*Send back information to idp about the n-factor auth*)
			SendSaml idp (?);
			authenticationprovider me idp
		else
			SendSaml idp (Failed Requester);
			authenticationprovider me idp
	| _ -> SendSaml idp (Failed Requester);
		authenticationprovider me idp
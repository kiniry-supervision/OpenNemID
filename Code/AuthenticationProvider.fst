module Authenticationprovider

open SamlProtocol
open Crpyto
open Database
(*Must send saml to identity provider about the ways of second
authentication method and what is the correct information.
Perhaps via the client. No contact to the client in this? Only IdP?*)
val authenticationprovider me:prin -> idp:prin -> unit
let rec authenticationprovider me idp =
	let req = ReceiveSaml idp in
	match req with
	| AuthnRequestMessage (issuer, destination, message, loginInfo, sigIdP) ->
		let pubkissuer = CertStore.GetPublicKey issuer in
		(*Add check for the blacklist / whitelist in db in the if statement before
		verifysignature*)
		if (whitelisted idp && VerifySignature issuer pubkissuer message sigIdP) then
			(assert (Log issuer message);
			match loginInfo with
			| CprLogin(cpr, password) ->
				if(!cprrevokedidp cpr idp && checkcprlogin cpr password) then
					(*Func for checking if this idp has been revoked by user*)
					(*Func for checking the login info*)
					(*Find the n-factor auth method - How / which one if more?*)
					let authmethod = cprgetnfactor cpr in
					SendSaml idp AuthResponseMessage authp idp Assertion(*?*) authmethod;
					authenticationprovider me idp
				else
					SendSaml idp (LoginFailed);
					authenticationprovider me idp
			| UserLogin(name, password) ->
				if(!revokedidp name idp && checkuserlogin name password) then
					(*Func for checking if this idp has been revoked by user*)
					(*Func for checking the login info*)
					(*Find the n-factor auth method - How / which one if more?*)
					let authmethod = getnfactor name in
					SendSaml idp AuthResponseMessage authp idp Assertion(*?*) authmethod;
					authenticationprovider me idp
				else
					SendSaml idp (LoginFailed);
					authenticationprovider me idp
			| _ -> SendSaml idp (Failed Requester);
				authenticationprovider me idp
		else
			SendSaml idp (Failed Requester);
			authenticationprovider me idp
	| _ -> SendSaml idp (Failed Requester);
		authenticationprovider me idp

(*Add database func*)
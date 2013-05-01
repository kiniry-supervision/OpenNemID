module Authenticationprovider

open SamlProtocol
open Crypto
open Database
(*Must send saml to identity provider about the ways of second
authentication method and what is the correct information.
Perhaps via the client. No contact to the client in this? Only IdP?*)

val createAssertion: me:prin -> user:prin -> authnReq:AuthnRequest -> Assertion

let createAssertion me user authnReq =
	match authnReq with
	| MkAuthnRequest(reqid,issueinst,dest,idp,msg,sigIdP) ->
		let assertion = IssueAssertion me user idp reqid in
        let myprivk = CertStore.GetPrivateKey me in
        assume(Log me assertion);
        let pubkidp = CertStore.GetPublicKey idp in
        let sigAs = Sign me myprivk assertion in
        let signAssertion = AddSignatureToAssertion assertion sigAs in
        let encryptedAssertion = EncryptAssertion idp pubkidp signAssertion in
        encryptedAssertion

val authenticationprovider: me:prin -> idp:prin -> user:prin -> unit

let rec authenticationprovider me idp user =
	let req = ReceiveSaml idp in
	match req with
	| AuthnRequestMessage (issuer, destination, message, loginInfo, sigIdP) ->
		let pubkissuer = CertStore.GetPublicKey issuer in
		(*Add check for the blacklist / whitelist in db in the if statement before
		verifysignature*)
		if (whitelisted idp) && (VerifySignature issuer pubkissuer message sigIdP) then
			(assert (Log issuer message);
			match loginInfo with
			| CprLogin(cpr, password) ->
				if (cprrevokedidp cpr idp) && (checkcprlogin cpr password) then
					(*Func for checking if this idp has been revoked by user*)
					(*Func for checking the login info*)
					(*Find the n-factor auth method - How / which one if more?*)
					let assertion = createAssertion me user message in
					let authmethod = cprgetnfactor cpr in
					SendSaml idp AuthResponseMessage me idp assertion authmethod;
					authenticationprovider me idp user
				else
					SendSaml idp (Failed User);
					authenticationprovider me idp user
			| UserLogin(name, password) ->
				if (revokedidp name idp) && (checkuserlogin name password) then
					(*Func for checking if this idp has been revoked by user*)
					(*Func for checking the login info*)
					(*Find the n-factor auth method - How / which one if more?*)
					let assertion = createAssertion me user message in
					let authmethod = getnfactor name in
					SendSaml idp AuthResponseMessage me idp assertion authmethod;
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
	| _ -> SendSaml idp (Failed Requester);
		authenticationprovider me idp user
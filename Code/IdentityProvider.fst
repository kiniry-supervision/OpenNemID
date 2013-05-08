module Identityprovider

open SamlProtocol
open Crypto
open TypeFunc

(*type SecurityRestriction = 
	| Session: 1
	| User: 2
	| IdP: 4

type SecurityProfile =
	| Profile:	prin -> SecurityRestriction ->
				int -> SecurityProfile
*)

val userloggedin: user:prin -> bool
val getjavascript: string
val decodeMessage: message:string -> AuthnRequest
val getauthnrequest: user:prin -> challenge:nonce -> AuthnRequest
val getuserchallenge: user:prin -> nonce
val relatechallenge: user:prin -> challenge:nonce -> unit
val verifychallenge: user:prin -> challenge:nonce -> bool
val relate: user:prin -> challenge:nonce -> authnReq:AuthnRequest -> unit

val handleUserAuthenticated: me:prin -> user:prin -> authnReq:AuthnRequest -> unit

let handleUserAuthenticated me user authnReq = 
	match authnReq with
	| MkAuthnRequest(issueinst,dest,sp,msg,sigSP) ->
		let pubksp = CertStore.GetPublicKey sp in
			if (VerifySignature sp pubksp msg sigSP) then
        	(assert (Log sp msg);
        	let assertion = IssueAssertion me user sp authnReq in
        	let myprivk = CertStore.GetPrivateKey me in
        	assume(Log me assertion);
        	let sigAs = Sign me myprivk assertion in
        	let signAssertion = AddSignatureToAssertion assertion sigAs in
        	let encryptedAssertion = EncryptAssertion sp pubksp signAssertion in
        	let resp = AuthResponseMessage me sp encryptedAssertion in
        	SendSaml user resp)
      else
        SendSaml user (Failed Requester)

val handleauthresponse: me:prin -> user:prin -> authp:prin -> unit

let handleauthresponse me user authp =
	let resp = ReceiveSaml authp in
	match resp with
	| LoginResponseMessage(issuer, destination, authmethod, challenge, sigUser) ->
		let pubkeyuser = CertStore.GetPublicKey user in
		if VerifySignatureAuth user pubkeyuser authmethod sigUser then
			(assert (LogAuth user authmethod);
			relatechallenge user challenge;
			let resp = UserAuthRequest authmethod challenge sigUser in
			SendSaml user resp)
		else
			SendSaml user (DisplayError 403)
	| LoginSuccess(status, issuer, destination) ->
		if (status = "OK") then
			let challenge = getuserchallenge user in
			let authnReq = getauthnrequest user challenge in
			handleUserAuthenticated me user authnReq
		else 
			SendSaml user (DisplayError 403)
	| _ -> SendSaml user (DisplayError 400)

val identityprovider: me:prin -> user:prin -> authp:prin -> unit

let rec identityprovider me user authp =
	let request = ReceiveSaml user in
	match request with
	| AuthnRequestMessage(issuer, destination, message, sigSP) ->
		let pubkissuer = CertStore.GetPublicKey issuer in
    	if (VerifySignature issuer pubkissuer message sigSP) then
      		(assert (Log issuer message);
      		let authnReq = decodeMessage message in
      		let myprivk = CertStore.GetPrivateKey me in
      		if not (userloggedin user) then
      			let challenge = GenerateNonce me in
      			relate user challenge authnReq;
      			relatechallenge user challenge;
      			let js = getjavascript in
      			assume(Log me js);
      			let myprivk = CertStore.GetJSPrivateKey me in
      			let sigIdP = Sign me myprivk js in
      			let resp = UserCredRequest js challenge sigIdP in
      			SendSaml user resp;
      			identityprovider me user authp
      		else
      			let assertion = IssueAssertion me user issuer authnReq in
        		assume(Log me assertion);
        		let myprivk = CertStore.GetPrivateKey me in
        		let pubksp = CertStore.GetPublicKey issuer in
        		let sigAs = Sign me myprivk assertion in
        		let signAssertion = AddSignatureToAssertion assertion sigAs in
        		let encryptedAssertion = EncryptAssertion issuer pubksp signAssertion in
        		let resp = AuthResponseMessage me issuer encryptedAssertion in
        		SendSaml user resp)
    	else
      		SendSaml user (Failed Requester);
      		identityprovider me user authp
	| Login (loginInfo, challenge) ->
		if (verifychallenge user challenge) then
			let req = LoginRequestMessage me authp loginInfo in
			SendSaml authp req;
			handleauthresponse me user authp;
			identityprovider me user authp
		else
			SendSaml user (DisplayError 400);
			identityprovider me user authp
	| UserAuthResponse(authInfo, challenge, sigAuth) ->
		let req = NfactAuthRequest me authp authInfo challenge sigAuth in
		SendSaml authp req;
		handleauthresponse me user authp;
		identityprovider me user authp
	| _ -> SendSaml user (DisplayError 400);
		identityprovider me user authp

module Identityprovider

open SamlProtocol
open Crypto

(*type SecurityRestriction = 
	| Session: 1
	| User: 2
	| IdP: 4

type SecurityProfile =
	| Profile:	prin -> SecurityRestriction ->
				int -> SecurityProfile
*)

val getauthnrequest: user:prin -> challenge:nonce -> AuthnRequest
val getuserchallenge: user:prin -> nonce
val relatechallenge: user:prin -> challenge:nonce -> unit
val relate: user:prin -> challenge:nonce -> authnReq:AuthnRequest -> unit
val generateid: id
val timestamp: string

val handleUserAuthenticated: me:prin -> user:prin -> authnReq:AuthnRequest -> unit

let handleUserAuthenticated me user authnReq = 
	match authnReq with
	| MkAuthnRequest(reqid,issueinst,dest,sp,msg,sigSP) ->
		let pubksp = CertStore.GetPublicKey sp in
			if (VerifySignature sp pubksp msg sigSP) then
        	(assert (Log sp msg);
        	let assertion = IssueAssertion me user sp reqid in
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
	| LoginResponseMessage(issuer, destination, encassertion, authmethod, challenge) ->
		let meprivk = CertStore.GetPrivateKey me in
		let assertion = DecryptAssertion me meprivk encassertion in
		match assertion with
		| SignedAssertion(token, sigAuthP) ->
			let pubkissuer = CertStore.GetPublicKey authp in
			if VerifySignature authp pubkissuer token sigAuthP then
				(assert (Log authp token);
				relatechallenge user challenge;
				let resp = UserAuthRequest authmethod challenge in
				SendSaml user resp)
			else SendSaml user (DisplayError 403)
		| _ -> SendSaml user (DisplayError 400)
	| LoginSuccess(status, issuer, destination, encassertion) ->
		let meprivk = CertStore.GetPrivateKey me in
		let assertion = DecryptAssertion me meprivk encassertion in
		match assertion with
		| SignedAssertion(token, sigAuthP) ->
			let pubkissuer = CertStore.GetPublicKey authp in
			if (status = "OK") && (VerifySignature authp pubkissuer token sigAuthP) then
				(assert (Log authp token);
				let challenge = getuserchallenge user in
				let authnReq = getauthnrequest user challenge in
				handleUserAuthenticated me user authnReq)
			else SendSaml user (DisplayError 403)
		| _ -> SendSaml user (DisplayError 400)
	| _ -> SendSaml user (DisplayError 400)

val identityprovider: me:prin -> user:prin -> authp:prin -> unit

let rec identityprovider me user authp =
	let request = ReceiveSaml user in
	match request with
	| AuthnRequestMessage(issuer, destination, message, sigSP) ->
		let pubkissuer = CertStore.GetPublicKey issuer in
    	if (VerifySignature issuer pubkissuer message sigSP) then
      		(assert (Log issuer message);
      		let id = generateid in
      		let issueinstant = timestamp in
      		let authnReq = MkAuthnRequest id issueinstant me issuer message sigSP in
      		let challenge = GenerateNonce me in
      		relate user challenge authnReq;
      		relatechallenge user challenge;
      		let resp = UserCredRequest challenge in
      		SendSaml user resp;
      		identityprovider me user authp)
    	else
      		SendSaml user (Failed Requester);
      		identityprovider me user authp
	| Login (loginInfo, challenge) ->
		let loginReq = CreateLoginRequestMessage me authp in
		assume(Log me loginReq);
		let myprivk = CertStore.GetPrivateKey me in
		let sigIdP = Sign me myprivk loginReq in
		let req = LoginRequestMessage me authp loginReq loginInfo sigIdP in
		SendSaml authp req;
		handleauthresponse me user authp;
		identityprovider me user authp
	| UserAuthResponse(authInfo, challenge) ->
		let authReq = CreateSecondAuthReqMessage me authp in
		assume(Log me authReq);
		let myprivk = CertStore.GetPrivateKey me in
		let sigIdP = Sign me myprivk authReq in
		let req = NfactAuthRequest me authp authReq authInfo challenge sigIdP in
		SendSaml authp req;
		handleauthresponse me user authp;
		identityprovider me user authp
	| _ -> SendSaml user (DisplayError 400);
		identityprovider me user authp

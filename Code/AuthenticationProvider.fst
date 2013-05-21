module Authenticationprovider

open SamlProtocol
open Crypto
open Database
open TypeFunc
open Messaging


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
					SendSaml idp (LoginFailure CredentialError);
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
						SendSaml idp (LoginFailure AuthError);
						authenticationprovider me idp user
				else
					SendSaml idp (LoginFailure AuthError);
					authenticationprovider me idp user
			| _ -> SendSaml idp (Failed Requester);
				authenticationprovider me idp user
		else
			SendSaml idp (Failed Requester);
			authenticationprovider me idp user
	| _ -> SendSaml idp (Failed Requester);
		authenticationprovider me idp user


val usercommunication: me:prin -> user:prin -> unit

let rec usercommunication me user =
	let req = ReceiveMessage user in
	match req with
	| RequestForLogin(passportnumber) -> 
		if createuser passportnumber then
			let challenge = GenerateNonce me in
			relatechallenge user challenge;
			SendMessage user (ReqLoginResponse challenge);
			usercommunication me user
		else
			SendMessage user (StatusMessage Unsuccessful);
			usercommunication me user
	| CreateLogin(generatedpassword, challenge) ->
		if (verifychallenge user challenge) && (usercreation user generatedpassword) then
			let challenge = GenerateNonce me in
			relatechallenge user challenge;
			SendMessage user (StatusMessage Successful);
			usercommunication me user
		else
			SendMessage user (StatusMessage Unsuccessful);
			usercommunication me user
	| ChangePassword(userid, password, newPassword) ->
		if changeuserpassword userid password newPassword then
			SendMessage user (StatusMessage Successful);
			usercommunication me user
		else
			SendMessage user (StatusMessage Unsuccessful);
			usercommunication me user
	| ChangeUserId(userid, newUserId, password) ->
		if changeuserid userid newUserId password then
			SendMessage user (StatusMessage Successful);
			usercommunication me user
		else
			SendMessage user (StatusMessage Unsuccessful);
			usercommunication me user
	| UserRevokeIdp(userid, password, idp) ->
		if revokeidp userid password idp then
			SendMessage user (StatusMessage Successful);
			usercommunication me user
		else
			SendMessage user (StatusMessage Unsuccessful);
			usercommunication me user
	| AddNfactor(userid, password, nfact) ->
		if addnfactor userid password nfact then
			SendMessage user (StatusMessage Successful);
			usercommunication me user
		else
			SendMessage user (StatusMessage Unsuccessful);
			usercommunication me user
	| RemoveNfactor(userid, password, nfact) ->
		if removenfactor userid password nfact then
			SendMessage user (StatusMessage Successful);
			usercommunication me user
		else
			SendMessage user (StatusMessage Unsuccessful);
			usercommunication me user
	| _ -> SendMessage user (StatusMessage Unsuccessful);
		usercommunication me user

val getsignedjavascript: string

val establishidp: me:prin -> idp:prin -> unit

let rec establishidp me idp =
	let req = ReceiveMessage idp in
	match req with
	| NewSiteRequest(idp) ->
		let challenge = GenerateNonce me in
		relatechallenge idp challenge;
		SendMessage idp (ChallengeResponse challenge);
		establishidp me idp
	| IdpChalResponse(challenge) ->
		if (verifychallenge idp challenge) && (addidp idp) then
			let idppubkey = CertStore.GetPublicKey idp in
			let mypubk = CertStore.GetPublicKey me in
			let signedjs = getsignedjavascript in
			let resp = AcceptedIdp idp idppubkey me mypubk signedjs in
			SendMessage idp resp;
			establishidp me idp
		else
			SendMessage idp (StatusMessage Unsuccessful);
			establishidp me idp
	| _ -> SendMessage idp (StatusMessage Unsuccessful);
		establishidp me idp
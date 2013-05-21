module Messaging

open Crypto
open TypeFunc

type Status =
	| Successful: Status
	| Unsuccessful: Status

type Message =
	| NewSiteRequest: idp:prin -> Message
	| ChallengeResponse: challenge:nonce -> Message
	| IdpChalResponse: challenge:nonce -> Message
	| AcceptedIdp: idp:prin -> pubkey:pubkey idp -> authp:prin -> authpubkey:pubkey authp -> signedjavascript:string -> Message
	| RequestForLogin: passportnumber:string -> Message
	| ReqLoginResponse: challenge:nonce -> Message
	| CreateLogin: generatedpassword:string -> challenge:nonce -> Message
	| ChangeUserId: userid:string -> newUserId:string -> password:string -> Message
	| ChangePassword: userid:string -> password:string -> newPassword:string -> Message
	| UserRevokeIdp: userid:string -> password:string -> idp:string -> Message
	| AddNfactor: userid:string -> password:string -> nfact:Authentication -> Message
	| RemoveNfactor: userid:string -> password:string -> nfact:Authentication -> Message
	| StatusMessage: Status -> Message


val SendMessage: prin -> Message -> unit
val ReceiveMessage: prin -> Message
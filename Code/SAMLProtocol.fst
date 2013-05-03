module SamlProtocol

open Crypto

type assertiontoken = string (*Add refinements*)
type signedtoken = string (*Add refinements*)
type id = string
type endpoint = string
type uri = string

type Authentication =
  | Facebook: id:int -> Authentication
  | SMS: generated:int -> Authentication
  | Google: id:int -> Authentication
  | OpenId: id:int -> Authentication

type AuthnRequest = 
  | MkAuthnRequest: id:string -> IssueInstant:string ->
                    Destination:endpoint -> Issuer:prin ->
                    message:string -> sig:dsig ->
                    AuthnRequest

type LoginData = 
  | MkLoginData:  user:prin -> signature:dsig ->
                  cert:pubkey user -> challenge:nonce ->
                  site:string -> data:string ->
                  LoginData

type LoginInfo =
  | UserLogin:  name:string -> password:string ->
                LoginInfo

type AuthInfo =
  | UserAuth:   name:string -> auth:Authentication ->
                AuthInfo

type Assertion =
  | SignedAssertion: assertiontoken -> dsig -> Assertion
  | EncryptedAssertion: cypher -> Assertion

type SamlStatus =
  | Success: SamlStatus
  | Requester: SamlStatus
  | Responder: SamlStatus
  | User: SamlStatus

type SamlMessage =
  | SPLogin: uri -> SamlMessage
  | Login: loginInfo:LoginInfo -> challenge:nonce -> SamlMessage
  | LoginResponse: string -> SamlMessage
  | AuthnRequestMessage: issuer:prin ->  destination:endpoint -> message:string -> dsig -> SamlMessage
  | LoginRequestMessage: issuer:prin ->  destination:endpoint -> message:string -> loginInfo:LoginInfo -> dsig -> SamlMessage
  | SecondAuthRequest: issuer:prin -> destination:endpoint -> message:string -> authInfo:AuthInfo -> challenge:nonce -> dsig -> SamlMessage
  | AuthResponseMessage: issuer:prin -> destination:endpoint -> Assertion -> SamlMessage
  | LoginResponseMessage: issuer:prin -> destination:endpoint -> Assertion -> authmethod:Authentication -> challenge:nonce -> SamlMessage
  | UserAuthenticated: status:string -> logindata:LoginData -> authnReq:AuthnRequest -> SamlMessage
  | UserCredRequest: challenge:nonce -> SamlMessage
  | UserAuthRequest: authmethod:Authentication -> challenge:nonce -> SamlMessage
  | UserAuthResponse: authInfo:AuthInfo -> challenge:nonce -> SamlMessage
  | LoginSuccess: status:string -> issuer:prin -> destination:endpoint -> Assertion -> SamlMessage
  | Failed: SamlStatus -> SamlMessage
  | DisplayError: int -> SamlMessage


val SendSaml: prin -> SamlMessage -> unit
val ReceiveSaml: prin -> SamlMessage 

val CreateAuthnRequestMessage: issuer:prin -> destination:prin -> string
val CreateLoginRequestMessage: issuer:prin -> destination:prin -> string
val CreateSecondAuthReqMessage: issuer:prin -> destination:prin -> string
val IssueAssertion: issuer:prin -> subject:prin -> audience:prin -> inresto:id -> assertiontoken
val MakeAssertion: issuer:prin -> subject:prin -> audience:prin -> assertiontoken
val AddSignatureToAssertion: assertiontoken -> dsig -> signedtoken
val EncryptAssertion: receiver:prin -> pubkey receiver -> signedtoken -> Assertion
val DecryptAssertion: receiver:prin -> privkey receiver -> Assertion -> (signedtoken * dsig)
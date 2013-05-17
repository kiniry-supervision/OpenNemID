module SamlProtocol

open Crypto
open TypeFunc

type assertiontoken = string (*Add refinements*)
type signedtoken = string (*Add refinements*)
type id = string
type endpoint = string
type uri = string


type AuthnRequest = 
  | MkAuthnRequest: IssueInstant:string ->
                    Destination:endpoint -> Issuer:prin ->
                    message:string -> sig:dsig ->
                    AuthnRequest

type LoginData = 
  | MkLoginData:  user:prin -> signature:dsig ->
                  cert:pubkey user -> challenge:nonce ->
                  site:string -> data:string ->
                  LoginData

type LoginInfo =
  | UserLogin:  userid:string -> password:string ->
                LoginInfo

type AuthInfo =
  | UserAuth:   userid:string -> authmethod:Authentication ->
                authresponse:Authentication -> AuthInfo

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
  | LoginRequestMessage: issuer:prin ->  destination:endpoint -> loginInfo:LoginInfo -> SamlMessage 
  | NfactAuthRequest: issuer:prin -> destination:endpoint -> authInfo:AuthInfo -> challenge:nonce -> dsig -> SamlMessage
  | AuthResponseMessage: issuer:prin -> destination:endpoint -> Assertion -> SamlMessage
  | LoginResponseMessage: issuer:prin -> destination:endpoint -> auth:Authentication -> challenge:nonce -> dsig -> SamlMessage
  | UserAuthenticated: status:string -> logindata:LoginData -> authnReq:AuthnRequest -> SamlMessage
  | UserCredRequest: javascript:string -> challenge:nonce -> dsig -> SamlMessage
  | UserAuthRequest: authmethod:Authentication -> challenge:nonce -> dsig -> SamlMessage
  | UserAuthResponse: authInfo:AuthInfo -> challenge:nonce -> dsig -> SamlMessage
  | LoginSuccess: status:string -> issuer:prin -> destination:endpoint -> SamlMessage
  | Failed: SamlStatus -> SamlMessage
  | DisplayError: int -> SamlMessage


val SendSaml: prin -> SamlMessage -> unit
val ReceiveSaml: prin -> SamlMessage 

val CreateAuthnRequestMessage: issuer:prin -> destination:prin -> string
val IssueAssertion: issuer:prin -> subject:prin -> audience:prin -> inresto:AuthnRequest -> assertiontoken
val AddSignatureToAssertion: assertiontoken -> dsig -> signedtoken
val EncryptAssertion: receiver:prin -> pubkey receiver -> signedtoken -> Assertion
val DecryptAssertion: receiver:prin -> privkey receiver -> Assertion -> (signedtoken * dsig)

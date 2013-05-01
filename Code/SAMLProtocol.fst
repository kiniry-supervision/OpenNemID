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
                  cert:pubkey user -> auth:Authentication ->
                  site:string -> data:string ->
                  LoginData

type LoginInfo =
  | UserLogin:  name:string -> password:string ->
                LoginInfo
  | CprLogin:   cpr:int -> password:string ->
                LoginInfo

type Assertion =
  | SignedAssertion: assertiontoken -> dsig -> Assertion
  | EncryptedAssertion: cypher -> Assertion

type SamlStatus =
  | Success: SamlStatus
  | Requester: SamlStatus
  | Responder: SamlStatus
  | User: SamlStatus

(*Define type for cpr so length = 10*)
type SamlMessage =
  | Login: LoginInfo -> SamlMessage
  | LoginResponse: string -> SamlMessage
  | AuthnRequestMessage: issuer:prin ->  destination:endpoint -> message:string -> loginInfo:LoginInfo -> dsig -> SamlMessage
  | AuthResponseMessage: issuer:prin -> destination:endpoint -> Assertion -> authmethod:Authentication -> SamlMessage
  | UserAuthenticated: status:string -> logindata:LoginData -> authmethod:Authentication -> SamlMessage
  | UserCredRequest: challenge:nonce -> SamlMessage
  | UserAuthRequest: authmethod:Authentication -> SamlMessage
  | Failed: SamlStatus -> SamlMessage
  | DisplayError: int -> SamlMessage


val SendSaml: prin -> SamlMessage -> unit
val ReceiveSaml: prin -> SamlMessage 

val CreateAuthnRequestMessage: issuer:prin -> destination:prin -> string
val IssueAssertion: issuer:prin -> subject:prin -> audience:prin -> inresto:id -> assertiontoken
val AddSignatureToAssertion: assertiontoken -> dsig -> signedtoken
val EncryptAssertion: receiver:prin -> pubkey receiver -> signedtoken -> Assertion
val DecryptAssertion: receiver:prin -> privkey receiver -> Assertion -> (signedtoken * dsig)
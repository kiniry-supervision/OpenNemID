module Authenticationprovider

open SamlProtocol
open Crpyto
(*Must send saml to identity provider about the ways of second
authentication method and what is the correct information.
Perhaps via the client. No contact to the client in this? Only IdP?*)
val authenticationprovider me:prin -> client:prin -> unit
let authenticationprovider me client =
	let req = ReceiveSaml client in
	match req with
	| AuthnRequestMessage (issuer, destination, message, dsig) ->
		lol
		authenticationprovider me client
	| _ -> SendSaml client (DisplayError 400);
		authenticationprovider me client
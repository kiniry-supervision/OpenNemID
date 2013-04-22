module Browser

open SamlProtocol

(*Handle the two-factor authentication*)
val browser: idp:prin -> res:uri -> user:string -> password:string -> unit

let browser idp res user password =
	let req = HttpGet resource in
	let _ = Send idp req in
		let response = Receive idp in
		match response with
		| SamlProtocolMessage (authp, authnRequest, sigIdP) ->
			let samlAuthnReq = SamlProtocolMessage authp authnRequest sigIdP in
			Send authp samlAuthnReq;
			
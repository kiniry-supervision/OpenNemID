module Browser

open SamlProtocol

(*Handle the two-factor authentication*)
val browser: sp:prin -> idp:prin -> res:uri -> user:string -> password:string -> unit

let browser idp resource user password =
	let req = SPLogin "Login" in
	let _ = SendSaml sp req in
		let res = ReceiveSaml sp in
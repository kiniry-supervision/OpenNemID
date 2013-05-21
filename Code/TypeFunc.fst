module TypeFunc

type Authentication =
  | OpenId: id:int -> Authentication
  | Facebook: id:int -> Authentication
  | SMS: generated:int -> Authentication
  | Yubico: generated:int -> Authentication

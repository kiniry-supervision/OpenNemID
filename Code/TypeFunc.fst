module TypeFunc

type Authentication =
  | Facebook: id:int -> Authentication
  | SMS: generated:int -> Authentication
  | Google: id:int -> Authentication
  | OpenId: id:int -> Authentication
class_name Order
enum { MOVE, ATTACK, GATHER }
var position: Vector2
var type: int


func _init(p: Vector2, t: int):
	position = p
	type = t

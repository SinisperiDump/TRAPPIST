class_name Gather extends Order

var from_pos: Vector2
var to_pos: Vector2
var resource: Ore
var quantity: int = 0


func _init(from: Vector2, to: Vector2) -> void:
	super._init(from)
	from_pos = from
	to_pos = to
	name = "Gather"


func go_back() -> void:
	var temp = from_pos
	from_pos = to_pos
	to_pos = temp


func stringify() -> String:
	return name + " order from" + str(from_pos) + " to " + str(to_pos) + " " + str(complete)

class_name Order
var position: Vector2
var complete: bool = false
var name: String = "Empty"


func _init(pos: Vector2) -> void:
	position = pos


func stringify() -> String:
	return name + " order to " + str(position) + " complete: " + str(complete)

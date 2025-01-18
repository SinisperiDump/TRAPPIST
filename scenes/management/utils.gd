extends Node


## Random number generator we can set our own seed if needed
var rng := RandomNumberGenerator.new()


func _ready() -> void:
	# Randomize so we get different seed each time game is lauched
	rng.randomize()


#region Between checks
## Returns true if float value is between given numbers
func int_between(value: int, min_value: int, max_value:int):
	if value >= min_value and value <= max_value:
		return true
	return false

## Returns true if float value is between given numbers
func float_between(value: float, min_value: float, max_value:float):
	if value >= min_value and value <= max_value:
		return true
	return false

## Return true if Vector2i point is inside given Rect2i
func vector2i_between(point: Vector2i, check_rect: Rect2i) -> bool:
	if int_between(point.x, check_rect.position.x, check_rect.size.x) and\
	int_between(point.y, check_rect.position.y, check_rect.size.y):
		return true
	return false
#endregion

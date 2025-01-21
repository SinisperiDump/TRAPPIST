extends Node

## Random number generator we can set our own seed if needed
var rng := RandomNumberGenerator.new()


func _ready() -> void:
	# Randomize so we get different seed each time game is lauched
	rng.randomize()


## Is vector approximately equal to another
## My implementation cause godot's doesn't allow me specify the epsilon
func vec2_approx_eq(a: Vector2, b: Vector2, eps: float) -> bool:
	return abs(a.x - b.x) < eps && abs(a.y - b.y) < eps


func choose_point_in_rad(center: Vector2, radius: float, minimum: float = 50.0) -> Vector2:
	var rad = randf_range(minimum, radius)
	var point = center + (Vector2.RIGHT * rad).rotated(randf_range(0.0, TAU))
	return point


#region Between checks
## Returns true if float value is between given numbers
func int_between(value: int, min_value: int, max_value: int) -> bool:
	if value >= min_value and value <= max_value:
		return true
	return false


## Returns true if float value is between given numbers
func float_between(value: float, min_value: float, max_value: float) -> bool:
	if value >= min_value and value <= max_value:
		return true
	return false


## Return true if Vector2i point is inside given Rect2i
func vector2i_between(point: Vector2i, check_rect: Rect2i) -> bool:
	if int_between(point.x, check_rect.position.x, check_rect.size.x) and int_between(point.y, check_rect.position.y, check_rect.size.y):
		return true
	return false
#endregion

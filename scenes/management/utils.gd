extends Node


## Random number generator we can set our own seed if needed
var rng := RandomNumberGenerator.new()


func _ready() -> void:
	# Randomize so we get different seed each time game is lauched
	rng.randomize()


#region Rays
# Shoots a ray from screen to 3D world
func screen_to_world_ray(screen_position: Vector2, mask: int, node_3d: Node3D, collide_with_bodies: bool = true, collide_with_areas: bool = true) -> Dictionary:
	var space_state = node_3d.get_world_3d().direct_space_state
	var camera: Camera3D = get_tree().root.get_camera_3d()
	var ray_origin: Vector3 = camera.project_ray_origin(screen_position)
	var ray_end: Vector3 = ray_origin + camera.project_ray_normal(screen_position) * 2000
	var ray = PhysicsRayQueryParameters3D.create(ray_origin, ray_end, mask)
	ray.collide_with_areas = collide_with_areas
	ray.collide_with_bodies = collide_with_bodies
	return space_state.intersect_ray(ray)
#endregion


#region Between checks
## Returns true if float value is between given numbers
func int_between(value: int, min_value: int, max_value:int) -> bool:
	if value >= min_value and value <= max_value:
		return true
	return false

## Returns true if float value is between given numbers
func float_between(value: float, min_value: float, max_value:float) -> bool:
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

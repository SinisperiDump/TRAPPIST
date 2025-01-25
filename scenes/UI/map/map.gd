extends PanelContainer

## draw a rect with camera current zoom and dimentions
var camera_position: Vector2
var margin: float = 4.0
@onready var timer: Timer = Timer.new()


## picks up data in the radius around of main base
## all units positions blue dots
## all buildings positions big blue dots
## all enemies positions red dots
func _ready() -> void:
	add_child(timer)
	timer.timeout.connect(_on_timer_timeout)
	timer.one_shot = false
	timer.start()


func _draw() -> void:
	for i in AlienManager.active_aliens:
		if AlienManager.active_aliens[i]:
			var coords = to_map_coordinates(AlienManager.active_aliens[i].global_position)
			if coords.x < 0.0 + margin || coords.x > self.size.x - margin || coords.y < 0.0 + margin || coords.y > self.size.y - margin:
				continue
			#var base_position: Vector2 = get_tree().get_first_node_in_group("base").global_position
			# if !is_in_radius(AlienManager.active_aliens[i].global_position, base_position, 3000.0):
			# 	continue
			draw_circle(coords, 2.0, Color.RED)
	for i in get_tree().get_nodes_in_group("unit"):
		draw_circle(to_map_coordinates(i.global_position), 2.0, Color.BLUE)


func to_map_coordinates(pos: Vector2) -> Vector2:
	pos = pos / Refs.world_size  # 8100 is a map size in px
	pos = (pos * self.size)
	return pos


func _on_timer_timeout() -> void:
	queue_redraw()


func is_in_radius(pos: Vector2, center: Vector2, rad: float) -> bool:
	return (pos - center).length() <= rad

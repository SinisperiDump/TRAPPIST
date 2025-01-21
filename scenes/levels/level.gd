extends Node2D


func _ready() -> void:
	Refs.camera.global_position = get_tree().get_first_node_in_group("base").global_position

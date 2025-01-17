class_name Main
extends Node

## Scene that will get loaded when game launches
@export var start_scene: PackedScene

## Keeps track what scene is currently active
var current_scene: Node

func _ready() -> void:
	current_scene = start_scene.instantiate()
	add_child(current_scene)

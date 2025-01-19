class_name Main
extends Node


## Scene that will get loaded when game launches
@export var main_menu: PackedScene
@export var game_world: PackedScene

## Keeps track what scene is currently active
var current_scene: Node


func _ready() -> void:
	current_scene = main_menu.instantiate()
	add_child(current_scene)
	current_scene.main_scene = self

## Switches game to main menu
func load_main_menu() -> void:
	_clear_current_scene()

	current_scene = main_menu.instantiate()
	add_child(current_scene)
	current_scene.main_scene = self

## Switches game to game world
func load_game_world() -> void:
	_clear_current_scene()

	current_scene = game_world.instantiate()
	add_child(current_scene)
	current_scene.main_scene = self

## Clears Scene that is currently active
func _clear_current_scene() -> void:
	if get_child_count() > 0:
		current_scene.queue_free()
		current_scene = null

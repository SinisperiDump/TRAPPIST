class_name GameWorld
extends Node

## Default level that will run when game start
@export var start_level: PackedScene
## Reference to main scene
var main_scene: Main

## Sun, Controls lighting of the level
@onready var sun: DirectionalLight2D = $Sun
## Node that holds all currently loaded levels as it's child
@onready var levels: Node = $Levels
## Node that holds all currently loaded Player Units as it's child
@onready var players: Node = $Players
## Node that holds all currently loaded Enemy Units as it's child
@onready var aliens: Node = $Aliens


func _ready() -> void:
	var new_level: Node2D = start_level.instantiate()
	levels.add_child(new_level)

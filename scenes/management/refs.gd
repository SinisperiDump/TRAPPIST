extends Node

## Size of the viewport
@onready var viewport_size: Vector2 = get_viewport().get_visible_rect().size
@onready var camera: Camera2D
@onready var world_size: Vector2
@onready var base_location: Vector2
@onready var current_level: Node

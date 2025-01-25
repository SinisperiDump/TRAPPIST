extends Node

## Size of the viewport
@onready var viewport_size: Vector2 = get_viewport().get_visible_rect().size
@onready var camera: Camera2D

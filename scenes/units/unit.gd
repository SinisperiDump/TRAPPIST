class_name Unit extends CharacterBody2D

@onready var click_detector: ClickDetector = %ClickDetector

@export var status: StatusComponent


func _ready() -> void:
	click_detector.mouse_entered.connect(func() -> void: print("fuck shit piss acum"))
	pass


func _process(delta: float) -> void:
	var mouse_pos: Vector2 = get_global_mouse_position()

## Parent class for all the interactible guys in the game: Player, units and enemies
## When creating an inherited class, make sure to call super._ready() in the child's _ready function

class_name Unit extends CharacterBody2D

@onready var click_detector: ClickDetector = %ClickDetector

@export var status: StatusComponent


func _ready() -> void:
	click_detector.mouse_entered.connect(_on_mouse_entered)
	click_detector.mouse_exited.connect(_on_mouse_exited)
	click_detector.click_detected.connect(_on_click_detected)


func _on_mouse_entered() -> void:  # virtual
	pass


func _on_mouse_exited() -> void:  # virtual
	pass


func _on_click_detected() -> void:
	pass

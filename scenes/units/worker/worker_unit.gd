extends CharacterBody2D

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

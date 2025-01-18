class_name ClickDetector extends Area2D

signal click_detected
var hovered: bool = false


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton && event.is_pressed() && hovered:
		if event.button_index == MOUSE_BUTTON_LEFT:
			click_detected.emit()


func _ready() -> void:
	self.mouse_entered.connect(func() -> void: hovered = true)
	self.mouse_exited.connect(func() -> void: hovered = false)

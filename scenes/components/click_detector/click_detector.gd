class_name ClickDetector extends Area2D

signal click_detected
signal hover
signal unhover


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton && event.is_pressed():
		if event.button_index == MOUSE_BUTTON_LEFT:
			click_detected.emit()


func _ready() -> void:
	self.mouse_entered.connect(func() -> void: hover.emit())
	self.mouse_exited.connect(func() -> void: unhover.emit())

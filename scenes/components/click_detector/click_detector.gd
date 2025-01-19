class_name ClickDetector extends Area2D

signal click_detected
var hovered: bool = false


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton && hovered:
		if !event.is_pressed():
			if event.button_index == MOUSE_BUTTON_LEFT:
				click_detected.emit()
				get_viewport().set_input_as_handled()
				print("dummy dum dum")

		get_viewport().set_input_as_handled()


func _ready() -> void:
	self.mouse_entered.connect(func() -> void: hovered = true)
	self.mouse_exited.connect(func() -> void: hovered = false)

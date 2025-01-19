class_name ClickDetector extends Area2D

signal click_detected
var hovered: bool = false

@export var unit: Node = null


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton && hovered:
		if event.is_pressed():
			if !unit.has_node("UnitDataComponent"):
				print("Frogot to add UnitDataComponent to Unit, you dum dum")
				return


			if event.button_index == MOUSE_BUTTON_LEFT:

				if event is InputEventWithModifiers && event.is_ctrl_pressed():
					EventBus.unit_selected.emit(unit, true)
					get_viewport().set_input_as_handled()
					click_detected.emit()
					return


				EventBus.unit_selected.emit(unit, false)
				get_viewport().set_input_as_handled()
				click_detected.emit()


func _ready() -> void:
	self.mouse_entered.connect(func() -> void: hovered = true)
	self.mouse_exited.connect(func() -> void: hovered = false)
	self.click_detected.connect(func() -> void: )

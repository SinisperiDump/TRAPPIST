class_name ClickDetector extends Area2D

signal right_click_detected
signal left_click_detected
var hovered: bool = false

@export var unit: Node = null

## dispatch get in range order if clicked on nemey building
## dispatch gather order if clicked on ore deposit or crystal deposit


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton && hovered:
		if event.is_pressed():
			if !unit.has_node("UnitDataComponent"):
				print("Frogot to add UnitDataComponent to Unit, you dum dum")
				return

			if event.button_index == MOUSE_BUTTON_LEFT:
				if event.is_pressed():
					if event is InputEventWithModifiers && event.is_ctrl_pressed():
						EventBus.unit_selected.emit(unit, true)
						get_viewport().set_input_as_handled()
						return

					match unit.unit_data.unit_type:
						UnitDataComponent.UnitType.WORKER:
							EventBus.unit_selected.emit(unit, false)
					left_click_detected.emit()
				get_viewport().set_input_as_handled()

			if event.button_index == MOUSE_BUTTON_RIGHT:
				if event.is_pressed():
					right_click_detected.emit()
				get_viewport().set_input_as_handled()


func _ready() -> void:
	self.mouse_entered.connect(func() -> void: hovered = true)
	self.mouse_exited.connect(func() -> void: hovered = false)

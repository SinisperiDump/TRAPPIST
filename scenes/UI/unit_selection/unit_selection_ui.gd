class_name UnitSelectionUI
extends PanelContainer


const UNIT_PORTRAIT = preload("res://scenes/UI/unit_selection/unit_portrait.tscn")
@export var unit_dispatcher: UnitDispatcher

@onready var selected_container: GridContainer = %SelectedContainer


func _ready() -> void:
	unit_dispatcher.unit_selection_changed.connect(_update_selected)


func _update_selected() -> void:
	_clear_grid()
	for unit_id in unit_dispatcher.selected_units:
		var new_portrait = UNIT_PORTRAIT.instantiate()
		selected_container.add_child(new_portrait)
		new_portrait.portrait = unit_dispatcher.selected_units[unit_id].unit_data.icon


func _clear_grid() -> void:
	for child in selected_container.get_children():
		child.queue_free()

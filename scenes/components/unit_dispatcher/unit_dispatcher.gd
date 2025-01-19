class_name UnitDispatcher extends Node

signal unit_pushed
signal unit_popped

var move_order_position: Vector2 = Vector2.ZERO

var selected_units: Dictionary = {}


func _unhandled_input(event: InputEvent) -> void:
	pass


func push_unit(unit: Node) -> void:
	selected_units[unit.get_instance_id()] = unit
	pass


func pop_unit(unit: Node) -> void:
	selected_units.erase(unit.get_instance_id())

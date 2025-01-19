class_name UnitDispatcher extends Node2D

signal unit_pushed(u: Node)
signal unit_popped(u: Node)
signal unit_selection_changed
@export var selectable_units: Node

var move_order_position: Vector2 = Vector2.ZERO

var selected_units: Dictionary = {}
var selection_rect: Rect2

var selection_start_pos: Vector2 = Vector2.ZERO

var drag_started: bool = false


func _ready() -> void:
	EventBus.unit_selected.connect(_on_single_unit_selected)


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.is_pressed():
				if !drag_started:
					selection_start_pos = get_global_mouse_position()
					drag_started = true

			if !event.is_pressed():  # button up
				if drag_started:
					unselect_units()
					add_units_to_selection()
					drag_started = false
					selection_rect = Rect2(0.0, 0.0, 0.0, 0.0)
					queue_redraw()

		if event.button_index == MOUSE_BUTTON_RIGHT && !event.is_pressed():
			if !selected_units.is_empty():
				dispatch_orders()

	if event is InputEventMouseMotion:
		if drag_started:
			var mp = get_global_mouse_position()
			var sp = selection_start_pos
			var diff = mp - sp
			selection_rect = Rect2(sp.x, sp.y, diff.x, diff.y)
			queue_redraw()


## Draw 2 selection rectengles one for border, another for the background
func _draw() -> void:
	if selection_rect.size != Vector2.ZERO:
		draw_rect(selection_rect, Color.GREEN, false, 2, false)
		draw_rect(selection_rect, Color(0.0, 1.0, 0.0, 0.07), true)


## Add unit to selected hash map
func push_unit(unit: Node) -> void:
	selected_units[str(unit.get_instance_id())] = unit
	unit_pushed.emit(unit)


## Remove unit from hash map
func pop_unit(unit: Node) -> void:
	unit_popped.emit(unit)


## Reset hash map and unselect every unit
func unselect_units() -> void:
	for key in selected_units:
		pop_unit(selected_units[key])
	selected_units = {}
	unit_selection_changed.emit()


## If unit in the selection box, add it to selection
func add_units_to_selection() -> void:
	var unit_array: Array[Node] = selectable_units.get_children()
	for unit in unit_array:
		if selection_rect.abs().has_point(unit.global_position):
			push_unit(unit)
	unit_selection_changed.emit()


## Add unit to selection or clear selection and add this unit
func _on_single_unit_selected(unit: Node, additive: bool) -> void:
	if additive:
		push_unit(unit)
		unit_selection_changed.emit()
		return

	unselect_units()
	push_unit(unit)
	unit_selection_changed.emit()


## Send move order to selected units if they are not a building and can walk
func dispatch_orders() -> void:
	# unit.move_to(mouse_position)
	var temp: Vector2 = get_global_mouse_position()
	for key in selected_units:
		# testing purposes
		if selected_units[key].unit_data.unit_type != UnitDataComponent.UnitType.BUILDING:
			var order_pos = temp
			selected_units[key].move_to(order_pos)
			temp = Utils.choose_point_in_rad(order_pos, 100, 100)
		else:
			print("Add move_to function to Unit to make it move")

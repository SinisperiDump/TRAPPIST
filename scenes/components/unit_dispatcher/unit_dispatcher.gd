class_name UnitDispatcher extends Node2D

signal unit_pushed(u: Node)
signal unit_popped(u: Node)

var move_order_position: Vector2 = Vector2.ZERO

var selected_units: Dictionary = {"asdf": 1234}
var selection_rect: Rect2

var selection_start_pos: Vector2 = Vector2.ZERO
var drag_started: bool = false
## Cklick on ground
## dispatch order if selected_units is not empty on button up
## if selected_units are empty nothing happens

## nomatter if selected_units is empty or not, start drawing box
## when mouse let go, stop drawing box and refresh selected units with whatever is under the box


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_pressed():
			if !drag_started:
				drag_started = true
				selection_start_pos = get_global_mouse_position()

		if !event.is_pressed():  # button up
			# stop drawing selection box
			# add guys to seled_units
			# if it is a new selection return here
			print("stop square")
			drag_started = false
			selection_rect = Rect2(0.0, 0.0, 0.0, 0.0)
			queue_redraw()

			if !selected_units.is_empty():
				dispatch_order()
	if event is InputEventMouseMotion:
		if drag_started:
			var mp = get_global_mouse_position()
			var sp = selection_start_pos
			selection_rect = Rect2(sp.x, sp.y, mp.x - sp.x, mp.y - sp.y)
			queue_redraw()


func draw_box() -> void:
	if selection_rect.size != Vector2.ZERO:
		draw_rect(selection_rect, Color.GREEN, false, 2, false)
		draw_rect(selection_rect, Color(0.0, 1.0, 0.0, 0.05), true)


func _draw() -> void:
	draw_box()


func push_unit(unit: Node) -> void:
	selected_units[unit.get_instance_id()] = unit
	unit_pushed.emit(unit)


func pop_unit(unit: Node) -> void:
	selected_units.erase(unit.get_instance_id())
	unit_popped.emit(unit)


func dispatch_order() -> void:
	print("dispatched order")

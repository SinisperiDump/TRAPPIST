extends Camera2D

@export_range(100.0, 2000.0, 10.0) var moving_speed: float = 800.0
@export_range(20.0, 300.0, 1.0) var panning_speed: float = 100.0
@export_range(0.0, 20.0, 1.0) var movement_smoothing: float = 10.0
@export var zoom_speed: float = 0.06

var push_force: float = 0.0

var direction: Vector2 = Vector2.ZERO
var velocity: Vector2 = Vector2.ZERO
var mouse_offset: Vector2 = Vector2.ZERO
var mouse_moving: bool = false

@onready var vp: Vector2 = get_viewport_rect().size
@onready var zoom_level: float = self.zoom.x
@onready var panning: bool = false


func _unhandled_input(event: InputEvent) -> void:
	mouse_moving = false
	if event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == MOUSE_BUTTON_WHEEL_UP:
				zoom_level += zoom_speed
			if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
				zoom_level -= zoom_speed
			if event.button_index == MOUSE_BUTTON_MIDDLE:
				panning = true
		else:
			if event.button_index == MOUSE_BUTTON_MIDDLE:
				panning = false
		zoom_level = clamp(zoom_level, 0.5, 2.0)
		return

	if event is InputEventMouseMotion && panning:
		mouse_moving = true
		mouse_offset = -event.relative / zoom_level
		# self.position += -event.relative / zoom_level


func _process(delta: float) -> void:
	handle_movement(delta)


func handle_movement(delta: float) -> void:
	if !panning:
		direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
		velocity = velocity.lerp(direction.normalized() * moving_speed * 2.0, delta * 10.0)
	else:
		velocity = velocity.lerp(mouse_offset * panning_speed, delta * 10.0)
		mouse_offset = Vector2.ZERO
	self.position += velocity * delta
	self.zoom = self.zoom.lerp(Vector2.ONE * zoom_level, delta * 10.0)

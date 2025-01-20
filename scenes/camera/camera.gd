extends Camera2D

@export var speed: float = 800.0
@export_range(0, 300, 1) var drag_margin_px: int = 15
@export var zoom_speed: float = 0.06

var push_force: float = 0.0

var direction: Vector2 = Vector2.ZERO
var velocity: Vector2 = Vector2.ZERO
var edge_scrolling: bool = false

@onready var vp: Vector2 = get_viewport_rect().size
@onready var zoom_level: float = self.zoom.x


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == MOUSE_BUTTON_WHEEL_UP:
				zoom_level += zoom_speed
			if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
				zoom_level -= zoom_speed
		zoom_level = clamp(zoom_level, 0.5, 2.0)
		self.zoom = Vector2.ONE * zoom_level


func _process(delta: float) -> void:
	detect_edge(delta)


func detect_edge(delta: float) -> void:
	direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var mp = get_viewport().get_mouse_position()

	if Input.is_mouse_button_pressed(MOUSE_BUTTON_MIDDLE):
		if mp.x <= 0.0 + drag_margin_px:
			direction = Vector2.LEFT
		elif mp.x >= vp.x - drag_margin_px:
			direction = Vector2.RIGHT
		elif mp.y <= 0.0 + drag_margin_px:
			direction = Vector2.UP
		elif mp.y >= vp.y - drag_margin_px:
			direction = Vector2.DOWN

	velocity = velocity.move_toward(direction.normalized() * speed, 50.0)

	self.position += velocity * delta

extends Camera2D

@onready var vp: Vector2 = get_viewport_rect().size

var push_force: float = 0.0
@export var speed: float = 300.0
@export_range(0.0, 30.0, 1.0) var drag_margin_px: float = 15.0

var direction: Vector2 = Vector2.ZERO
var velocity: Vector2 = Vector2.ZERO


func _process(delta: float) -> void:
	detect_edge(delta)


func detect_edge(delta: float) -> void:
	direction = Vector2.ZERO
	var mp = get_viewport().get_mouse_position()

	if mp.x <= 0.0 + drag_margin_px:
		direction = Vector2.LEFT
	if mp.x >= vp.x - drag_margin_px:
		direction = Vector2.RIGHT
	if mp.y <= 0.0 + drag_margin_px:
		direction = Vector2.UP
	if mp.y >= vp.y - drag_margin_px:
		direction = Vector2.DOWN
		print("edge")

	velocity = velocity.move_toward(direction.normalized() * speed, 10.0)

	self.position += velocity * delta

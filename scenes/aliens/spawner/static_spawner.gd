extends Node2D

@export var aliens: Array[PackedScene]
@export var quantity: int = 0
@export_range(0.0, 10.0, 0.1) var spawn_rate_ms: float = 1.0
@onready var area: CollisionShape2D = get_child(0)
var current_tick: float = 0.0


func _ready() -> void:
	assert(area is CollisionShape2D, "Spawn area is not a CollisionShapet2D node!")


func _physics_process(delta: float) -> void:
	current_tick += delta
	if current_tick >= spawn_rate_ms:
		current_tick = 0.0
		spawn_alien()


func spawn_alien() -> void:
	var alien = AlienManager.create_alien()
	if alien:
		alien.revive()
		var spawn_location: Vector2 = Vector2.ZERO
		var radius: float = area.get_shape().radius
		spawn_location = Utils.choose_point_in_rad(self.global_position, radius, radius / 10.0)
		alien.global_position = spawn_location

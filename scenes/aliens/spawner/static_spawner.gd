extends Node2D

@export var aliens: Array[PackedScene]
@export var quantity: int = 0
@export_range(0.0, 10.0, 0.1) var spawn_rate_ms: float = 1.0
var spawn_area: CollisionShape2D = null
var radius: float
var current_tick: float = 0.0
var current_quantitiy: int = 0


func _ready() -> void:
	var a = get_child(0)
	assert(a, "No spawn area has been added to the static spawner " + name)
	assert(a is CollisionShape2D, "Spawn area is not a CollisionShapet2D node!")
	spawn_area = a
	radius = spawn_area.get_shape().radius


func _physics_process(delta: float) -> void:
	current_tick += delta
	if current_tick >= spawn_rate_ms && current_quantitiy < quantity:
		current_quantitiy += 1
		current_tick = 0.0
		spawn_alien()


func spawn_alien() -> void:
	var alien: Alien = AlienManager.create_alien()
	if alien:
		var spawn_location = Utils.choose_point_in_rad(self.global_position, radius, radius / 10.0)
		alien.global_position = spawn_location
		alien.spawn_type = Alien.SpawnType.NEST
		alien.init()

extends Path2D

@export_range(0.1, 10.0, 0.1) var spawn_rate_sec: float = 1.0
@export var disabled: bool = false
@export var num_aliens: int = 0
var current_tick: float = 0.0
var current_alien_num: int = 0

@onready var spawn_location: PathFollow2D = %SpawnLocation


func _ready() -> void:
	if disabled:
		set_physics_process(false)


func _physics_process(delta: float) -> void:
	current_tick += delta
	if current_tick >= spawn_rate_sec:
		current_tick = 0.0
		spawn_aliens()


func spawn_aliens() -> void:
	if current_alien_num < num_aliens:
		spawn_location.set_progress(randi())
		var alien_scene: Node2D = AlienManager.create_alien()
		if alien_scene:
			current_alien_num += 1
			alien_scene.position = spawn_location.position
			alien_scene.rotation = spawn_location.rotation + PI / 2
			alien_scene.spawn_type = Alien.SpawnType.WAVE
			alien_scene.init()

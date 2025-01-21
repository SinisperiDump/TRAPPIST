extends Path2D

@export_range(0.1, 10.0, 0.1) var spawn_rate_sec: float = 1.0
@export var aliens: Array[PackedScene]
@export var disabled: bool = false
var current_tick: float = 0.0

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
	for alien in aliens:
		spawn_location.set_progress(randi())
		var alien_scene: Node2D = AlienManager.create_alien()
		if alien_scene:
			alien_scene.revive()
			alien_scene.position = spawn_location.position
			alien_scene.rotation = spawn_location.rotation + PI / 2

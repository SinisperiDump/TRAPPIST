class_name Alien extends Area2D

enum SpawnType { WAVE, NEST }
var spawn_type: SpawnType = SpawnType.WAVE
@export var data: AlienData = null
@onready var target_position: Vector2 = self.global_position
@onready var nav_agent: NavigationAgent2D = %NavigationAgent2D
@onready var base_position: Vector2 = get_tree().get_first_node_in_group("base").global_position
var velocity: Vector2 = Vector2.ZERO
var dead: bool = false

var t: float = 10.0
var tt: float = 0.0


func _physics_process(delta: float) -> void:
	position += (target_position - self.global_position).normalized() * data.speed * delta

	## temp to make them die when they reach base
	if Utils.vec2_approx_eq(position, target_position, 80) && spawn_type == SpawnType.WAVE:
		if !dead:
			die()


## disable maximum amount of stuff here
func die() -> void:
	dead = true
	rotation_degrees = 0.0
	hide()
	AlienManager.remove_alien(get_instance_id())


func init() -> void:
	match spawn_type:
		SpawnType.WAVE:
			target_position = base_position
		SpawnType.NEST:
			target_position = self.global_position
	dead = false
	show()


## temporarily enable things here
func engage(target: Vector2) -> void:
	target_position = target


func attack() -> void:
	## play certain animation
	pass

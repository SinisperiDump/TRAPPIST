class_name Alien extends Area2D

enum SpawnType { WAVE, NEST }
enum State { IDLE, MOVING, ATTACKING }
@export var data: AlienData = null

#debug
@onready var hp_bar: ProgressBar = $ProgressBar
@onready var hp_label: Label = %HpLabel
var t: float = 10.0
var tt: float = 0.0
#########
var spawn_type: SpawnType = SpawnType.WAVE
var current_state: State = State.IDLE
var velocity: Vector2 = Vector2.ZERO
var current_health: float = 0.0
var dead: bool = false

@onready var target_position: Vector2 = self.global_position
@onready var nav_agent: NavigationAgent2D = %NavigationAgent2D
@onready var base_position: Vector2 = get_tree().get_first_node_in_group("base").global_position


func _physics_process(delta: float) -> void:
	do_state(delta)
	DEBUG_FUN(delta)


## disable and reset maximum amount of stuff here
func die() -> void:
	hide()
	dead = true
	rotation_degrees = 0.0
	AlienManager.remove_alien(get_instance_id())


func init() -> void:
	dead = false
	current_health = data.max_health
	hp_bar.max_value = current_health
	hp_bar.value = data.max_health
	hp_label.text = str(hp_bar.value) + " ---- type " + str(spawn_type)
	match spawn_type:
		SpawnType.WAVE:
			target_position = base_position
			current_state = State.MOVING
		SpawnType.NEST:
			target_position = self.global_position
			current_state = State.IDLE
	show()


func do_state(delta: float) -> void:
	match current_state:
		State.IDLE:
			pass
		State.MOVING:
			position += (target_position - self.global_position).normalized() * data.speed * delta
			pass
		State.ATTACKING:
			pass
		_:
			return


## temporarily enable things here when get detected by palyer's unit
func engage(target: Vector2) -> void:
	target_position = target
	current_state = State.ATTACKING


## get triggered
func attack() -> void:
	## play certain animation
	## enable and disable weapon colliders
	pass


func DEBUG_FUN(delta: float) -> void:
	## temp to make them die when they reach base
	if Utils.vec2_approx_eq(position, target_position, 80) && spawn_type == SpawnType.WAVE:
		current_health -= delta
		hp_bar.value = current_health
		hp_label.text = str(hp_bar.value) + " ---- type " + str(spawn_type)
		if current_health <= 0.0:
			if !dead:
				die()
	if spawn_type == SpawnType.NEST:
		current_health -= delta * 3
		hp_bar.value = current_health
		hp_label.text = str(hp_bar.value) + " ---- type " + str(spawn_type)
		if current_health <= 0.0:
			if !dead:
				die()

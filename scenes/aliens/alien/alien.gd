class_name Alien extends Area2D

enum SpawnType { WAVE, NEST }
enum State { IDLE, GETTING_IN_RANGE, CHASE, ATTACKING }
@export var data: AlienData = null
@export_range(0.0, 10.0, 0.1) var chase_time: float
var current_chase_time: float = 0.0
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
var combat_target: Node = null
var spawn_position: Vector2 = Vector2.ZERO

@onready var nav_agent: NavigationAgent2D = %NavigationAgent2D
@onready var sprite: AnimatedSprite2D = %AnimatedSprite2D
@onready var base_position: Vector2 = get_tree().get_first_node_in_group("base").global_position
@onready var target_position: Vector2 = self.global_position
## navigation enabled only when spawned in the nest
## add visibility notifier
## chase timer
## do some damage to combat target
## somehow figure out when our combat target is dead, so we can return to spawn or continue going towards base


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
	hp_label.text = str(hp_bar.value) + " ---- type " + str(spawn_type) + " State: " + str(current_state)
	match spawn_type:
		SpawnType.WAVE:
			target_position = base_position
			current_state = State.IDLE
		SpawnType.NEST:
			target_position = self.global_position
			spawn_position = self.global_position
			current_state = State.IDLE
	show()


func do_state(delta: float) -> void:
	match current_state:
		State.IDLE:
			be_idle(delta)
		State.GETTING_IN_RANGE:
			move_to(combat_target.global_position, delta)

			if has_reached_target(combat_target.global_position):
				current_state = State.ATTACKING

		State.CHASE:
			current_chase_time += delta
			move_to(combat_target.global_position, delta)

			if current_chase_time >= chase_time:
				current_state = State.IDLE

		State.ATTACKING:
			attack()
		_:
			return


## temporarily enable things here when get detected by palyer's unit
func engage(target: Node) -> void:
	target.died.connect(func() -> void: current_state = State.IDLE ; print("going idle"))
	combat_target = target
	current_chase_time = 0.0
	print("going engage")
	current_state = State.GETTING_IN_RANGE


func chase() -> void:
	current_state = State.CHASE
	pass


## get triggered
func attack() -> void:
	## play certain animation
	sprite.play("swarm_attack")
	combat_target.take_damage(10)


func DEBUG_FUN(delta: float) -> void:
	## temp to make them die when they reach base
	if Utils.vec2_approx_eq(position, target_position, 80) && spawn_type == SpawnType.WAVE:
		current_health -= delta
		hp_bar.value = current_health
		hp_label.text = str(hp_bar.value) + " ---- type " + str(spawn_type) + " State: " + str(current_state)
		if current_health <= 0.0:
			if !dead:
				die()
	if spawn_type == SpawnType.NEST:
		current_health -= delta * 3
		hp_bar.value = current_health
		hp_label.text = str(hp_bar.value) + " ---- type " + str(spawn_type) + " State: " + str(current_state)
		if current_health <= 0.0:
			if !dead:
				die()


func has_reached_target(target: Vector2) -> bool:
	return Utils.vec2_approx_eq(position, target, 80)


func be_idle(delta: float) -> void:
	match spawn_type:
		SpawnType.WAVE:
			move_to(base_position, delta)
		SpawnType.NEST:
			move_to(spawn_position, delta)


func move_to(target: Vector2, delta: float) -> void:
	position += (target - self.global_position).normalized() * data.speed * delta

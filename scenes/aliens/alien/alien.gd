class_name Alien extends Area2D

enum SpawnType { WAVE, NEST }
enum State { IDLE, GETTING_IN_RANGE, CHASE, ATTACKING }
@export var data: AlienData = null
@export_range(0.0, 10.0, 0.1) var chase_time: float
var current_chase_time: float = 0.0
#debug
var idle_target: Vector2
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

var current_target: Vector2
var previous_target: Vector2

@onready var nav_agent: NavigationAgent2D = %NavigationAgent2D
@onready var sprite: AnimatedSprite2D = %AnimatedSprite2D
@onready var base_position: Vector2 = get_tree().get_first_node_in_group("base").global_position
@onready var target_position: Vector2 = self.global_position
@onready var nav_map: RID = get_tree().root.get_world_2d().navigation_map

## navigation enabled only when spawned in the nest
var nav_path: PackedVector2Array
## add visibility notifier
## + chase timer
## + do some damage to combat target
## + somehow figure out when our combat target is dead, so we can return to spawn or continue going towards base


func _ready() -> void:
	var path = NavigationServer2D.map_get_path(nav_map, self.position, base_position, true)
	print(path)


func _physics_process(delta: float) -> void:
	do_state(delta)
	handle_movement(delta)
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
			idle_target = base_position
			target_position = base_position
			current_state = State.IDLE
		SpawnType.NEST:
			idle_target = self.global_position
			target_position = self.global_position
			spawn_position = self.global_position
			current_state = State.IDLE
	show()


func do_state(delta: float) -> void:
	if current_state == State.IDLE:
		be_idle()

	elif current_state == State.GETTING_IN_RANGE:
		move_to(combat_target.global_position, delta)

		if has_reached_target(combat_target.global_position):
			current_state = State.ATTACKING

	elif current_state == State.CHASE:
		current_chase_time += delta
		move_to(combat_target.global_position, delta)

		if current_chase_time >= chase_time:
			combat_target = null
			current_state = State.IDLE

	else:
		attack()


## temporarily enable things here when get detected by palyer's unit
func engage(target: Node) -> void:
	if !combat_target:
		target.died.connect(_on_target_died)
		combat_target = target
	current_chase_time = 0.0
	current_state = State.GETTING_IN_RANGE


func _on_target_died() -> void:
	current_state = State.IDLE
	current_chase_time = 0.0
	combat_target = null


func chase() -> void:
	if !combat_target:
		return
	current_state = State.CHASE


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


func be_idle() -> void:
	current_target = idle_target


func move_to(target: Vector2, delta: float) -> void:
	#position += (target - self.global_position).normalized() * data.speed * delta
	current_target = target


func handle_movement(delta: float) -> void:
	#return
	if !Utils.vec2_approx_eq(current_target, previous_target, 64.0):
		#nav_agent.set_target_position(current_target)
		previous_target = current_target

	var direction = current_target - self.global_position
	position += direction.normalized() * data.speed * delta

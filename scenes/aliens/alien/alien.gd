class_name Alien extends Area2D

enum SpawnType { WAVE, NEST }
enum State { IDLE, GETTING_IN_RANGE, CHASE, ATTACKING }
@export var data: AlienData = null
@export_range(0.0, 10.0, 0.1) var chase_time: float
var current_chase_time: float = 0.0
#debug
@onready var hp_bar: ProgressBar = %ProgressBar
@onready var hp_label: Label = %HpLabel
var t: float = 10.0
var tt: float = 0.0
#########
var spawn_type: SpawnType = SpawnType.WAVE
var current_state: State = State.IDLE
var velocity: Vector2 = Vector2.ZERO
var current_health: float = 0.0
var dead: bool = false

@onready var sprite: AnimatedSprite2D = %AnimatedSprite2D
## move it somewhere where it's not goonna be read every 0.01 sec
## NAVIGATION=================
# targets
var current_target: Vector2

## TODO: convert to dicts of current combat targets
var combat_target: Node = null
var idle_target: Vector2  ## either base position or spawn poisition
## ==================
@onready var base_position: Vector2 = get_tree().get_first_node_in_group("base").global_position
var spawn_position: Vector2 = Vector2.ZERO
#==================
@onready var nav_map: RID = get_tree().root.get_world_2d().navigation_map
var nav_path: PackedVector2Array
var current_nav_index: int = 0
var direction: Vector2 = Vector2.ZERO
## add visibility notifier

## + chase timer
## + do some damage to combat target
## + somehow figure out when our combat target is dead, so we can return to spawn or continue going towards base


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
	## debug==================================
	hp_bar.max_value = current_health
	hp_bar.value = data.max_health
	hp_label.text = str(hp_bar.value) + " ---- type " + str(spawn_type) + " State: " + str(current_state)
	###=======================================
	if spawn_type == SpawnType.WAVE:
		idle_target = base_position
	else:
		idle_target = self.global_position
	be_idle()
	show()


func do_state(delta: float) -> void:
	if current_state == State.IDLE:
		return

	elif current_state == State.GETTING_IN_RANGE:
		generate_path(combat_target.global_position)

		if has_reached_target(combat_target.global_position):
			current_state = State.ATTACKING

	elif current_state == State.CHASE:
		if current_chase_time >= chase_time:
			combat_target = null
			be_idle()
			return

		current_chase_time += delta
		generate_path(combat_target.global_position)

	else:
		attack()


## temporarily enable things here when get detected by palyer's unit
func engage(target: Node) -> void:
	if !combat_target:
		if !target.died.is_connected(_on_target_died):
			target.died.connect(_on_target_died)
		combat_target = target
	current_chase_time = 0.0
	current_state = State.GETTING_IN_RANGE


func _on_target_died() -> void:
	combat_target.died.disconnect(_on_target_died)
	print("should go idle")
	be_idle()
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


func has_reached_target(target: Vector2) -> bool:
	return Utils.vec2_approx_eq(self.global_position, target, 80)


func be_idle() -> void:
	current_state = State.IDLE
	generate_path(idle_target)


## compare current target position with previous target position
## get path from nav server - once or when the target is different
## store it as an array of positions - same
func generate_path(target: Vector2) -> void:
	if Utils.vec2_approx_eq(target, current_target, 32.0):
		return

	current_nav_index = 0
	current_target = target
	nav_path = NavigationServer2D.map_get_path(nav_map, self.global_position, target, true)
	await get_tree().physics_frame


## got to each position one by one
## compare current target position with current global position
## when we reach desired position, increament the index and go to the next one
## when we there, reset the index
func handle_movement(delta: float) -> void:
	if !Utils.vec2_approx_eq(self.global_position, nav_path[current_nav_index], 10.0):
		position += direction.normalized() * data.speed * delta
		direction = nav_path[current_nav_index] - self.global_position
	else:
		if current_nav_index < nav_path.size() - 1:
			current_nav_index += 1


func DEBUG_FUN(delta: float) -> void:
	# temp to make them die when they reach base
	if Utils.vec2_approx_eq(position, current_target, 80) && spawn_type == SpawnType.WAVE:
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

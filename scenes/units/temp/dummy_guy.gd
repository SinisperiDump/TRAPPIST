extends CharacterBody2D
signal died(unit: Node)
signal took_damage(hp: float)
@onready var unit_data: UnitDataComponent = $UnitDataComponent
@onready var status: StatusComponent = %StatusComponent
@onready var navigation: NavigationComponent = %NavigationComponent
@onready var aggrevator: Area2D = %AlienAggrevator

enum State { IDLE, MOVING, ATTACKING }
var current_state: State
var nav_target: Vector2

var combat_targets: Dictionary = {}
var current_combat_target: Node = null

var attack_freq: float = 1.0
var curr_attack: float = 0.0


func _ready() -> void:
	status.init_stats(unit_data.get_base_stats())
	status.health.value_zero.connect(_on_health_zero)
	aggrevator.area_entered.connect(_on_alien_spotted)
	aggrevator.area_exited.connect(_on_alien_lost)
	aggrevator.body_entered.connect(_on_nest_spotted)


func _physics_process(_delta: float) -> void:
	if current_state == State.IDLE:
		pass
	elif current_state == State.MOVING:
		if Utils.vec2_approx_eq(self.global_position, nav_target, 64.0):
			current_state = State.IDLE
	else:
		curr_attack += _delta
		if curr_attack > attack_freq:
			curr_attack = 0.0
			attack()


func move_to(pos: Vector2) -> void:
	navigation.set_target(pos, status.speed.value)


func get_in_range(pos: Vector2) -> void:
	move_to(pos)


func attack() -> void:
	if current_combat_target:
		print("is connected ", current_combat_target.died.is_connected(_on_alien_killed))
		current_combat_target.take_damage(unit_data.base_damage)
	else:
		current_state = State.IDLE


func take_damage(damage: float) -> void:
	status.take_damage(damage)
	took_damage.emit(status.health.value)


func _on_health_zero() -> void:
	current_state = State.IDLE
	aggrevator.disable()
	died.emit(self)
	hide()
	queue_free()


func execute_order(order: Order) -> void:
	nav_target = order.position
	match order.type:
		## currently they are the same
		## potentially add patroling order etc
		Order.MOVE:
			current_state = State.MOVING
			move_to(order.position)
		Order.ATTACK:
			current_state = State.MOVING
			move_to(order.position)
	pass


## ============ COMBAT


func _on_alien_spotted(area: Area2D) -> void:
	move_to(self.global_position)
	current_state = State.ATTACKING
	combat_targets[area.get_instance_id()] = area
	if !area.died.is_connected(_on_alien_killed):
		area.died.connect(_on_alien_killed)
	if !current_combat_target:
		pick_combat_target()


func _on_alien_lost(area: Area2D) -> void:
	combat_targets.erase(area.get_instance_id())
	if area == current_combat_target:
		pick_combat_target()


func _on_nest_spotted(_body: Node) -> void:
	current_state = State.ATTACKING


func pick_combat_target() -> void:
	if combat_targets.size():
		for i in combat_targets:
			current_combat_target = combat_targets[i]
			return
	current_combat_target = null


func _on_alien_killed(alien: Node) -> void:
	alien.died.disconnect(_on_alien_killed)
	combat_targets.erase(alien.get_instance_id())
	if alien == current_combat_target:
		print("change target")
		pick_combat_target()
		if current_combat_target:
			if current_combat_target.dead:
				print("chosen target is dead")
		else:
			print("nobody to attack")
	if !current_combat_target:
		current_state = State.IDLE

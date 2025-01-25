extends CharacterBody2D
signal health_zero(unit: Node)
signal took_damage(hp: float)
@onready var unit_data: UnitDataComponent = $UnitDataComponent
@onready var status: StatusComponent = %StatusComponent
@onready var navigation: NavigationComponent = %NavigationComponent
@onready var aggrevator: Area2D = %AlienAggrevator
@onready var click_detector: ClickDetector = %ClickDetector
enum State { IDLE, MOVING, ATTACKING }
var current_state: State
var current_order: Order
var prev_order: Order
var nav_target: Vector2

var combat_targets: Dictionary = {}
var current_combat_target: Node = null

var attack_freq: float = 1.0
var curr_attack: float = 0.0


func _ready() -> void:
	click_detector.left_click_detected.connect(func() -> void: EventBus.unit_selected.emit(self, false))
	click_detector.ctrl_click_detected.connect(func() -> void: EventBus.unit_selected.emit(self, true))

	status.init_stats(unit_data.get_base_stats())
	status.health.value_zero.connect(_on_health_zero)
	aggrevator.area_entered.connect(_on_alien_spotted)
	aggrevator.area_exited.connect(_on_alien_lost)
	aggrevator.body_entered.connect(_on_nest_spotted)


func _physics_process(_delta: float) -> void:
	if current_state == State.ATTACKING:
		curr_attack += _delta
		if curr_attack > attack_freq:
			curr_attack = 0.0
			attack()


func move_to(pos: Vector2) -> void:
	nav_target = pos
	navigation.set_target(pos, status.speed.value)


func get_in_range(pos: Vector2) -> void:
	move_to(pos)


func attack() -> void:
	if current_combat_target:
		current_combat_target.take_damage(unit_data.base_damage)
	else:
		current_state = State.IDLE
		current_order.complete = true
		print("exectuting prev_order", self.global_position == prev_order.position, prev_order is Attack)
		execute_order(prev_order)


func take_damage(damage: float) -> void:
	status.take_damage(damage)
	took_damage.emit(status.health.value)


func _on_health_zero() -> void:
	current_state = State.IDLE
	aggrevator.disable()
	health_zero.emit(self)
	hide()
	queue_free()


func execute_order(order: Order) -> void:
	prev_order = current_order
	current_order = order
	## currently they are the same
	## potentially add patroling order etc
	if !current_order || current_order.complete:
		current_state = State.IDLE
		return
	if current_order is Move:
		current_state = State.MOVING
		move_to(order.position)
	elif current_order is Attack:
		current_state = State.ATTACKING
		move_to(order.position)
	elif current_order is Gather:
		current_state = State.MOVING
		move_to(order.from_pos)


## ============ COMBAT


func _on_alien_spotted(area: Area2D) -> void:
	current_state = State.ATTACKING
	var order = Attack.new(self.global_position)
	execute_order(order)
	combat_targets[area.get_instance_id()] = area
	if !area.died.is_connected(_on_alien_killed):
		area.died.connect(_on_alien_killed)
	if !current_combat_target:
		pick_combat_target()


func _on_alien_lost(area: Area2D) -> void:
	combat_targets.erase(area.get_instance_id())
	if area == current_combat_target:
		pick_combat_target()


func _on_nest_spotted(nest: Node) -> void:
	var order = Attack.new(self.global_position)
	execute_order(order)
	current_state = State.ATTACKING
	combat_targets[nest.get_instance_id()] = nest
	if !nest.destroyed.is_connected(_on_nest_destroyed):
		nest.destroyed.connect(_on_nest_destroyed)
	if !current_combat_target:
		pick_combat_target()


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
		pick_combat_target()
	if !current_combat_target:
		current_state = State.IDLE
		execute_order(prev_order)


func _on_nest_destroyed(nest: Node) -> void:
	nest.destroyed.disconnect(_on_nest_destroyed)
	combat_targets.erase(nest.get_instance_id())
	if nest == current_combat_target:
		pick_combat_target()
	if !current_combat_target:
		current_state = State.IDLE
		execute_order(prev_order)

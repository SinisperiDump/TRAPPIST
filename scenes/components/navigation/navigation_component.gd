class_name NavigationComponent extends Node2D

@export var actor: CharacterBody2D = null
@onready var nav_agent: NavigationAgent2D = %NavigationAgent2D
## Frequency of navigation path query
@export_range(0.0, 10.0, 0.02) var tick_ms: float

@onready var current_target: Vector2 = self.global_position
@onready var previous_target: Vector2 = self.global_position

var ticks: float = 0.0

var desired_speed: float = 0.0


func _ready() -> void:
	assert(actor, "No actor has been set on navigation compoenent")
	nav_agent.velocity_computed.connect(_on_velocity_computed)


func _physics_process(delta: float) -> void:
	ticks += delta
	if ticks >= tick_ms:
		ticks = 0.0
		do_navigation()


func _on_velocity_computed(safe_velocity: Vector2) -> void:
	if Utils.vec2_approx_eq(safe_velocity, Vector2.ZERO, 0.0):
		actor.velocity = Vector2.ZERO
	else:
		actor.velocity = safe_velocity
	actor.move_and_slide()


## Set the target and the speed with which to move to it
func set_target(target: Vector2, speed: float) -> void:
	current_target = target
	desired_speed = speed


func do_navigation() -> void:
	if !Utils.vec2_approx_eq(current_target, previous_target, 64.0):
		nav_agent.set_target_position(current_target)
		previous_target = current_target

	var dir = nav_agent.get_next_path_position() - self.global_position
	var desired_velocity: Vector2 = Vector2.ZERO
	desired_velocity.x = dir.normalized().x * desired_speed
	desired_velocity.y = dir.normalized().y * (desired_speed - desired_speed / 3)

	nav_agent.set_velocity(desired_velocity)

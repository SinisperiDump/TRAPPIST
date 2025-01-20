extends Area2D

## No collision
## Visible on screen notif
## Object pooling -> having an array of guys already allocated. Instead of deleting guys we are reusing them
## Ghosts -> if alien is not on screen and not dead and needs to be moving, only update the position of the guy

enum SpawnType { WAVE, NEST }
@export var spawn_type: SpawnType
@export var target_node: Node = null
@onready var target_position: Vector2 = self.global_position
@onready var nav_tick: float = 1.0
@onready var nav_agent: NavigationAgent2D = %NavigationAgent2D

var curr_tick: float = 0.0
var velocity: Vector2 = Vector2.ZERO


func _ready() -> void:
	if target_node:
		target_position = target_node.global_position
	else:
		nav_agent.set_target_position(target_node.global_position)


func _physics_process(delta: float) -> void:
	velocity = (self.position - target_position).normalized() * 100.0 * delta
	position += velocity


func respawn(_new_pos: Vector2) -> void:
	## reset stats and position
	pass


func disable_everything() -> void:
	## when we are not on screen or died
	pass

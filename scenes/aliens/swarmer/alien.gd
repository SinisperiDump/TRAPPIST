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
var dead: bool = false
var with_navigation: bool = false


func _physics_process(delta: float) -> void:
	position += (Vector2.ZERO - self.global_position).normalized() * 300.0 * delta
	if Utils.vec2_approx_eq(position, Vector2.ZERO, 80):
		if !dead:
			die()


func die() -> void:
	dead = true
	hide()
	AlienManager.remove_alien(get_instance_id())


func revive() -> void:
	dead = false
	show()

extends Area2D

@export var aggrevation_area: CollisionShape2D = null
@export var user: Node = null


func _ready() -> void:
	assert(aggrevation_area, "No aggrevation area for aggrevator has been provided on the " + get_parent().name)
	self.area_entered.connect(_on_alien_entered)
	self.area_exited.connect(_on_alien_exited)


func _on_alien_entered(area: Area2D) -> void:
	area.engage(user)


func _on_alien_exited(area: Area2D) -> void:
	area.chase()


func disable() -> void:
	aggrevation_area.disabled = true

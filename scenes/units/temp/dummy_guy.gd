extends CharacterBody2D

var speed: float = 330.0
@onready var unit_data: UnitDataComponent = $UnitDataComponent

@onready var target: Vector2 = self.global_position


func _process(_delta: float) -> void:
	var dir = (target - self.global_position).normalized()
	self.velocity = dir * speed
	move_and_slide()


func move_to(pos: Vector2) -> void:
	target = pos

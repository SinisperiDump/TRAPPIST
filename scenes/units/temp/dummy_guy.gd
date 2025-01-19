extends CharacterBody2D

var speed: float = 0.0


func _process(delta: float) -> void:
	self.velocity = Vector2.RIGHT * speed
	move_and_slide()


func move_to() -> void:
	speed = 300.0

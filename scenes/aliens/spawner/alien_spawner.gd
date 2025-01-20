extends Node2D

@export var aliens: Array[PackedScene]
@export var quantity: int = 0


func _ready() -> void:
	for i in range(quantity):
		for j: PackedScene in aliens:
			var alien = j.instantiate()  ## grab from alien pool to reuse instead of creating new ones
			add_child(alien)

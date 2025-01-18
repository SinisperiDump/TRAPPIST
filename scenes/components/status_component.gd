class_name StatusComponent
extends Node

@export_group("Life")
## Units health
@export var health: Stat
## Units shield
@export var shield: Stat
## Units armor
@export var armor: Stat
@export_group("Movement")
## units movement speed
@export var speed: Stat

func _ready() -> void:
	health.value = health.max_total()
	shield.value = shield.max_total()
	armor.value = armor.max_total()
	speed.value = speed.max_total()

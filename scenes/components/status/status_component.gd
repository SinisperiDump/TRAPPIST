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


func init_health(new_max_value: float) -> void:
	health.max_value = new_max_value
	health.value = health.max_total()


func init_shield(new_max_value: float) -> void:
	shield.max_value = new_max_value
	shield.value = shield.max_total()


func init_armor(new_max_value: float) -> void:
	armor.max_value = new_max_value
	armor.value = armor.max_total()


func init_speed(new_max_value: float) -> void:
	speed.max_value = new_max_value
	speed.value = speed.max_total()


## Take damage [Shield -> Armor -> Health]
func take_damage(damage: float) -> void:
	# Shield
	if shield.value_total() > 0:
		if damage > shield.temp_value:
			damage -= shield.temp_value
			shield.temp_value = 0.0
		else:
			shield.temp_value -= damage
			return
		
		if damage > shield.value:
			damage -= shield.value
			shield.value = 0.0
		else:
			shield.value -= damage
			return

	# Armor
	if armor.value_total() > 0:
		damage = max(1.0, damage - armor.value_total())

	# Health
	if health.value_total() > 0:
		if damage > health.temp_value:
			damage -= health.temp_value
			health.temp_value = 0.0
		else:
			health.temp_value -= damage
			return
		
		if damage > health.value:
			damage -= health.value
			health.value = 0.0
		else:
			health.value -= damage
			return

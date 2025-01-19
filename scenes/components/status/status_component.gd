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


func init_stats(new_values: Array[float]) -> void:
	health.max_value = new_values[0]
	health.value = health.max_total()
	shield.max_value = new_values[1]
	shield.value = shield.max_total()
	armor.max_value = new_values[2]
	armor.value = armor.max_total()
	speed.max_value = new_values[3]
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

class_name UnitDataComponent
extends Node


enum UnitType { BUILDING, WORKER, COMBAT}
@export var unit_type: UnitType = UnitType.BUILDING
@export var unit_name: String = ""
@export var icon: Texture2D
@export var is_enemy: bool = false

@export_group("Base stats")
@export var base_health: float
@export var base_armor: float
@export var base_shield: float
@export var base_speed: float


func get_base_stats() -> Array[float]:
	return [base_health, base_shield, base_armor, base_speed]

class_name UnitDataComponent
extends Node


enum UnitType { BUILDING, WORKER, COMBAT}
@export var unit_type: UnitType = UnitType.BUILDING
@export var unit_name: String = ""

@export_group("Base stats")
@export var base_health: float
@export var base_armor: float
@export var base_shield: float
@export var base_speed: float

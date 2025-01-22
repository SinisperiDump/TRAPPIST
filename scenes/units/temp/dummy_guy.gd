extends CharacterBody2D
signal died
var speed: float = 330.0
@onready var unit_data: UnitDataComponent = $UnitDataComponent
@onready var status: StatusComponent = %StatusComponent
@onready var navigation: NavigationComponent = %NavigationComponent
@onready var aggrevator: Area2D = %AlienAggrevator


func _ready() -> void:
	status.init_stats(unit_data.get_base_stats())
	status.health.value_zero.connect(_on_health_zero)


func move_to(pos: Vector2) -> void:
	navigation.set_target(pos, status.speed.value)


func take_damage(damage: float) -> void:
	status.take_damage(damage)


func _on_health_zero() -> void:
	aggrevator.disable()
	died.emit()
	hide()

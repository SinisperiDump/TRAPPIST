extends CharacterBody2D

var speed: float = 330.0
@onready var unit_data: UnitDataComponent = $UnitDataComponent
@onready var status: StatusComponent = %StatusComponent
@onready var navigation: NavigationComponent = %NavigationComponent


func _ready() -> void:
	status.init_stats(unit_data.get_base_stats())


func move_to(pos: Vector2) -> void:
	navigation.set_target(pos, status.speed.value)

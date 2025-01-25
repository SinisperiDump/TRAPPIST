extends StaticBody2D

signal destroyed(nest: Node)
@export var unit_data: UnitDataComponent
@export var status: StatusComponent
@onready var click_detector: ClickDetector = $ClickDetector


func _ready() -> void:
	status.init_stats(unit_data.get_base_stats())
	status.health.value_zero.connect(func() -> void: destroyed.emit(self) ; queue_free())
	click_detector.right_click_detected.connect(_on_right_click)


func _on_right_click() -> void:
	var order = Attack.new(self.global_position)
	EventBus.unit_order_created.emit(order)


func take_damage(damage: float) -> void:
	status.take_damage(damage)


func _enter_tree() -> void:
	GameData.nest_created()


func _exit_tree() -> void:
	GameData.nest_destroyed()

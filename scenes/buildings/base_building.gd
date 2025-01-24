class_name BaseBuilding
extends Node2D
signal health_zero(unit: Node)
@onready var click_detector: ClickDetector = $ClickDetector
@onready var status: StatusComponent = $StatusComponent
@onready var unit_data: UnitDataComponent = $UnitDataComponent


func _ready() -> void:
	click_detector.right_click_detected.connect(_on_clicked)

	status.init_stats(unit_data.get_base_stats())
	%ProgressBar.max_value = status.health.max_value
	%ProgressBar.value = status.health.value
	status.health.value_zero.connect(_on_being_destroyed)


func _on_clicked() -> void:
	print("Anyone who reads this smells bad.")


func take_damage(damage: float) -> void:
	%ProgressBar.value = status.health.value
	status.take_damage(damage)


func _on_being_destroyed() -> void:
	EventBus.game_lost.emit()
	health_zero.emit(self)
	queue_free()

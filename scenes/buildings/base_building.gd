class_name BaseBuilding
extends Node2D
signal health_zero(unit: Node)
@onready var click_detector: ClickDetector = $ClickDetector
@onready var status: StatusComponent = $StatusComponent
@onready var unit_data: UnitDataComponent = $UnitDataComponent
@onready var unit_detector: Area2D = %UnitDetectionArea

var metal: int = 0
var rad: int = 0


func _ready() -> void:
	click_detector.right_click_detected.connect(_on_clicked)

	status.init_stats(unit_data.get_base_stats())
	%ProgressBar.max_value = status.health.max_value
	%ProgressBar.value = status.health.value
	status.health.value_zero.connect(_on_being_destroyed)
	unit_detector.body_entered.connect(_on_unit_entered)


func _on_clicked() -> void:
	print("Anyone who reads this smells bad.")


func take_damage(damage: float) -> void:
	%ProgressBar.value = status.health.value
	status.take_damage(damage)


func _on_being_destroyed() -> void:
	EventBus.game_lost.emit()
	health_zero.emit(self)
	queue_free()


func _on_unit_entered(unit: Node) -> void:
	if unit.current_order is Gather:
		if unit.current_order.quantity:
			match unit.current_order.resource.type:
				Ore.Type.RADIOACTIVE_MAT:
					rad += unit.current_order.quantity
				_:
					metal += unit.current_order.quantity
			prints("rad", rad, "met", metal)
			unit.current_order.quantity = 0
			unit.current_order.go_back()
			unit.execute_order(unit.current_order)

class_name BaseBuilding
extends Node2D

@onready var click_detector: ClickDetector = $ClickDetector
@onready var status: StatusComponent = $StatusComponent
@onready var unit_data: UnitDataComponent = $UnitDataComponent


func _ready() -> void:
	click_detector.right_click_detected.connect(_on_clicked)

	status.init_stats(unit_data.get_base_stats())


func _on_clicked() -> void:
	var order = Order.new(self.global_position, Order.ATTACK)
	EventBus.unit_order_created.emit(order)
	print("Anyone who reads this smells bad.")

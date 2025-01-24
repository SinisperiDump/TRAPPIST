extends Area2D

@export var ore: Ore
@export var capacity: int = 0
@onready var click_detector: ClickDetector = %ClickDetector
@onready var base_position: Vector2 = get_tree().get_first_node_in_group("base").global_position


func _ready() -> void:
	click_detector.right_click_detected.connect(_on_right_click)
	self.body_entered.connect(_on_unit_entered)


func _on_right_click() -> void:
	var order = Order.new(self.global_position, Order.GATHER)
	EventBus.unit_order_created.emit(order)


func _on_unit_entered(unit: Node) -> void:
	if unit.current_order:
		if unit.current_order.type == Order.GATHER:
			var order = Order.new(base_position, Order.GATHER)
			unit.inventory = {"ore_type": ore, "quantity": 1}
			EventBus.unit_order_created.emit(order)

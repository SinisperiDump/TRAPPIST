extends Area2D

@export var ore: Ore
@export var capacity: int = 0
@onready var click_detector: ClickDetector = %ClickDetector
@onready var base_position: Vector2 = get_tree().get_first_node_in_group("base").global_position


func _ready() -> void:
	click_detector.right_click_detected.connect(_on_right_click)
	self.body_entered.connect(_on_unit_entered)


func _on_right_click() -> void:
	var order = Gather.new(self.global_position, base_position)
	EventBus.unit_order_created.emit(order)


func _on_unit_entered(unit: Node) -> void:
	if unit.current_order:
		if unit.current_order is Gather:
			var new_order = Gather.new(unit.current_order.to_pos, unit.current_order.from_pos)
			new_order.resource = ore
			new_order.quantity = 1
			unit.execute_order(new_order)

	else:
		print("no current order", unit.current_order)

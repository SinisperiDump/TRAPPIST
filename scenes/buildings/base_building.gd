class_name BaseBuilding
extends Node2D


@onready var click_detector: ClickDetector = $ClickDetector
@onready var status: StatusComponent = $StatusComponent
@onready var unit_data: UnitDataComponent = $UnitDataComponent


func _ready() -> void:
	click_detector.click_detected.connect(_on_clicked)
	
	status.init_health(unit_data.base_health)
	status.init_shield(unit_data.base_shield)
	status.init_armor(unit_data.base_armor)
	status.init_speed(unit_data.base_speed)

func _on_clicked() -> void:
	print("Anyone who reads this smells bad.")

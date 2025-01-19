class_name BaseBuilding
extends Node2D

@onready var status_component: StatusComponent = $StatusComponent
@onready var click_detector: ClickDetector = $ClickDetector

func _ready() -> void:
	click_detector.click_detected.connect(_on_clicked)

func _on_clicked() -> void:
	print("Anyone who reads this smells bad.")

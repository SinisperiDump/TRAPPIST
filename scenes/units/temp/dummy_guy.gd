extends CharacterBody2D

@onready var click_detector: ClickDetector = %ClickDetector

var speed: float = 0.0


func _ready() -> void:
	click_detector.click_detected.connect(_on_click_detected)


func _on_click_detected() -> void:
	EventBus.unit_selected.emit(self)


func _process(delta: float) -> void:
	self.velocity = Vector2.RIGHT * speed
	move_and_slide()


func move_to() -> void:
	speed = 300.0

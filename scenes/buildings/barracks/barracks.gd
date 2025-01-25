extends Node2D

var in_build_mode: bool = false
var can_build: bool = true
@onready var click_detector: ClickDetector = %ClickDetector
@onready var build_mode_collider: Area2D = %BuildModeCollider
@onready var collider: CollisionPolygon2D = %Collider


func _ready() -> void:
	click_detector.left_click_detected.connect(_on_left_click)
	build_mode_collider.body_entered.connect(_on_body_entered)
	build_mode_collider.body_exited.connect(_on_body_exited)
	if in_build_mode:
		collider.disabled = true
		self.modulate = Color.GREEN * 0.8


func _physics_process(_delta: float) -> void:
	if in_build_mode:
		self.global_position = get_global_mouse_position()


func _on_left_click() -> void:
	if in_build_mode && can_build:
		collider.disabled = false
		in_build_mode = false
		GameData.in_build_mode = false
		self.modulate = Color.WHITE


func _on_body_entered(_body: Node) -> void:
	if in_build_mode:
		can_build = false
		self.modulate = Color.RED * 0.8


func _on_body_exited(_body: Node) -> void:
	if in_build_mode:
		can_build = true
		self.modulate = Color.GREEN * 0.8

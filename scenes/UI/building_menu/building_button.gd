extends PanelContainer

signal button_hovered(desc: String)

@onready var button: TextureButton = %TextureButton
@export var icon: Texture2D
@export var description: String
@export var building_scene: PackedScene


func _ready() -> void:
	button.mouse_entered.connect(_on_mouse_hover)
	button.pressed.connect(_on_mouse_clicked)
	button.texture_normal = icon


func _on_mouse_hover() -> void:
	button_hovered.emit(description)


func _on_mouse_clicked() -> void:
	if GameData.in_build_mode:
		return
	var building = building_scene.instantiate()
	building.in_build_mode = true
	GameData.in_build_mode = true
	Refs.current_level.add_child(building)

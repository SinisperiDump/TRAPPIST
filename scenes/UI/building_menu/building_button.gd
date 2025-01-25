extends PanelContainer

signal button_hovered(desc: String)

@onready var button: TextureButton = %TextureButton
@export var icon: Texture2D
@export var description: String


func _ready() -> void:
	button.mouse_entered.connect(_on_mouse_hover)


func _on_mouse_hover() -> void:
	button_hovered.emit(description)

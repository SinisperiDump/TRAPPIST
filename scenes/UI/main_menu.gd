class_name MainMenu
extends Control


var main_scene: Main

@onready var start_button: Button = %StartButton
@onready var settings_button: Button = %SettingsButton
@onready var credits_button: Button = %CreditsButton


func _ready() -> void:
	start_button.pressed.connect(_on_start_pressed)
	settings_button.pressed.connect(_on_settings_pressed)
	credits_button.pressed.connect(_on_credits_pressed)

func _on_start_pressed() -> void:
	main_scene.load_game_world()

func _on_settings_pressed() -> void:
	pass

func _on_credits_pressed() -> void:
	pass

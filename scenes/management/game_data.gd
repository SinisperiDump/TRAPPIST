extends Node

var alien_nests_left: int = 0


func nest_created() -> void:
	alien_nests_left += 1


func nest_destroyed() -> void:
	alien_nests_left -= 1
	if alien_nests_left <= 0:
		EventBus.game_won.emit()
		print("game won")


func reset() -> void:
	alien_nests_left = 0

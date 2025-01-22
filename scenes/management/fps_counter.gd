extends Label


func _process(_delta: float) -> void:
	self.text = "FPS: " + str(Engine.get_frames_per_second()) + "\nAlien count: " + str(AlienManager.alien_count)

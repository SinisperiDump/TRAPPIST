extends Node

var active_aliens: Dictionary = {}
var inactive_aliens: Array[Node2D] = []

## in the future there is going to be something here
var ghosts: Dictionary = {}

var alien_count: int = 0
var max_alien_count: int = 100
var alien_scene: PackedScene = preload("res://scenes/aliens/alien/alien.tscn")
var swarmer_data: AlienData = preload("res://resources/aliens/swarmer_data.tres")
var spewer_data: AlienData = preload("res://resources/aliens/spewer_data.tres")
var jaggernaut_data: AlienData = preload("res://resources/aliens/jaggernaut_data.tres")
var alien_holder: Node = null


func create_alien() -> Node2D:
	print(alien_count)
	if alien_count < max_alien_count:
		alien_count += 1
		if inactive_aliens.is_empty():
			if !alien_holder:
				alien_holder = get_tree().get_first_node_in_group("aliens")
			var new_alien = alien_scene.instantiate()
			alien_holder.add_child(new_alien)
			active_aliens[new_alien.get_instance_id()] = new_alien
			new_alien.data = get_random_data()
			return new_alien
		else:
			var new_alien = inactive_aliens.pop_front()
			active_aliens[new_alien.get_instance_id()] = new_alien
			new_alien.data = get_random_data()
			return new_alien
	else:
		return null


func remove_alien(id: int) -> void:
	var alien = active_aliens[id]
	active_aliens.erase(id)
	inactive_aliens.push_back(alien)
	alien_count -= 1


func get_random_data() -> AlienData:
	var data = null
	var rand = randf()
	if rand <= 0.1:
		data = jaggernaut_data
	if rand < 0.5:
		data = spewer_data
	else:
		data = swarmer_data
	return data

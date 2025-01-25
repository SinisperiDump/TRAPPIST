extends Node2D


func _ready() -> void:
	Refs.camera.global_position = get_tree().get_first_node_in_group("base").global_position
	var tilemap_size = %TileMapLayer.get_used_rect().size
	var tile_size = %TileMapLayer.get_tile_set().tile_size

	Refs.world_size.x = tilemap_size.x * tile_size.x
	Refs.world_size.y = tilemap_size.y * tile_size.y / 2

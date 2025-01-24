extends PanelContainer

var portrait: Texture2D:
	set(texture_in):
		texture_rect.texture = texture_in

@onready var texture_rect: TextureRect = %TextureRect
@onready var health_bar: TextureProgressBar = %HealthBar


func init(unit: Node) -> void:
	portrait = unit.unit_data.icon
	health_bar.max_value = unit.status.health.max_value
	health_bar.value = unit.status.health.value
	unit.took_damage.connect(_update_health_bar)


func _update_health_bar(val: float) -> void:
	health_bar.value = val
